<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
    name: assert-az-cli-can-access
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Assert-AzCliCanAccess.Tests.ps1
    cites:
      - ADR-AZ-CLI#1
      - ADR-AZ-DATAMOD
  config:
    synopsis: Asserts the current az CLI login can reach the named subscription.
    description: |-
      The azure.yml-aware companion to the generic Assert-AzCliSubscriptionAccessible: it
      takes a subscription *name* (a key in azure.yml's subscriptions), resolves it to a subscription id
      via Get-AzureSubscription, and delegates the real-ARM-read access check down. Drop it at the top of
      a function to fail fast before it calls az against that subscription — whether the subscription is
      the active one or supplied via `--subscription <id>`.

      This is to access what Assert-AzCliIsConnected is to active-context: same name resolution, different
      question. "IsConnected" asks whether the session is *set to* the subscription; "CanAccess" asks
      whether the current login can *reach* it, independent of which subscription is active.
      See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md) and
      [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
    parameters:
      Subscription: Subscription name (a key in azure.yml's subscriptions).
    examples:
      - Assert-AzCliCanAccess apex_nonprod
      - Assert-AzCliCanAccess shared_nonprod
---
#>

function Assert-AzCliCanAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    Assert-AzCliSubscriptionAccessible -SubscriptionId $subscriptionDescriptor.id
}
