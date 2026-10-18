<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1
    name: get-az-cli-session-subscription
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1
    cites:
      - ADR-AZ-SESSION
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
