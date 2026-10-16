<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
    name: get-az-cli-session-subscription
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1
    cites:
      - ADR-AZ-SESSION
  config:
    synopsis: Resolves the az session's active subscription to its declared azure.yml identity.
    description: |-
      The reverse lookup that makes the session the deploy-target selector: reads the active subscription
      (Get-CurrentAzSubscription — in a pipeline, exactly what the service connection logged into), finds
      the azure.yml subscription with that GUID, and returns the declared identity. Read-only — it never
      logs in or switches context (verify is not connect,
      [ADR-AZ-SESSION](/docs/adr/azure/az-session-verification.md));
      config defines correct, so a session pointed at a subscription azure.yml does not declare is an
      error, not a fallback.
    outputs: |-
      An ordered dictionary: @{ name; id; customer; tenant } — `name` is the azure.yml subscription key,
      `customer` the canonical customer key ('' for a non-customer subscription), `tenant` the resolved
      tenant object.
    examples:
      - '(Get-AzCliSessionSubscription).name      # -> apex_nonprod  (whatever the session is set to)'
      - '(Get-AzCliSessionSubscription).customer  # -> apex  ('''' for a non-customer subscription)'
---
#>

function Get-AzCliSessionSubscription {
    [CmdletBinding()]
    param()

    $current = Get-CurrentAzSubscription
    $azure = Get-Config -Config azure

    $declared = @($azure.subscriptions.Keys | Where-Object { "$($azure.subscriptions[$_].id)" -eq "$($current.Id)" })
    if ($declared.Count -eq 0) {
        throw "The az session's subscription '$($current.Name)' ($($current.Id)) is not declared in azure.yml — the session must target a declared subscription (run 'az account set', or declare it). Declared: $(@($azure.subscriptions.Keys | Sort-Object) -join ', ')"
    }
    if ($declared.Count -gt 1) {
        throw "The az session's subscription id $($current.Id) is declared more than once in azure.yml ($(@($declared | Sort-Object) -join ', ')) — subscription ids must be unique"
    }

    $subscription = Get-AzureSubscription $declared[0]

    [ordered]@{
        name     = $subscription.name
        id       = $subscription.id
        customer = $subscription.customer
        tenant   = $subscription.tenant
    }
}
