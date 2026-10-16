<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
    name: test-az-cli-can-access
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Test-AzCliCanAccess.Tests.ps1
    cites:
      - ADR-AZ-CLI#1
      - ADR-AZ-DATAMOD
  config:
    synopsis: Tests whether the current az CLI login can reach the named subscription.
    description: |-
      The azure.yml-aware companion to the generic Test-AzCliSubscriptionAccessible: it takes
      a subscription *name* (a key in azure.yml's subscriptions), resolves it to a subscription id via
      Get-AzureSubscription, and delegates the real-ARM-read access check down. Returns $true when the
      current login can reach the subscription, $false otherwise (including not logged in). A pure query —
      it never throws on a mismatch. Use Assert-AzCliCanAccess for the throwing companion.

      "IsConnected" asks whether the session is *set to* the subscription; "CanAccess" asks whether the
      current login can *reach* it, independent of which subscription is active.
      See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md) and
      [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
    parameters:
      Subscription: Subscription name (a key in azure.yml's subscriptions).
    examples:
      - if (Test-AzCliCanAccess apex_nonprod) { Deploy-Bicep develop sample -Subscription apex_nonprod }
---
#>

function Test-AzCliCanAccess {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    Test-AzCliSubscriptionAccessible -SubscriptionId $subscriptionDescriptor.id
}
