<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliIsConnected.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Cli/tests/Test-AzCliIsConnected.Tests.ps1
  config:
    synopsis: Tests whether the active az CLI session is logged into the named tenant + subscription.
    description: |-
      Returns $true when `az account show` reports the tenant + subscription that azure.yml resolves for
      the named subscription (via Get-AzureSubscription), $false otherwise (including not-logged-in). A pure
      query — it never throws on a mismatch. Use Assert-AzCliIsConnected for the throwing companion (with a
      remediation message). A connection is subscription-scoped, so the input is the subscription name;
      delegates to the generic Test-AzCliConnected.
    parameters:
      Subscription: Subscription name (a key in azure.yml's subscriptions).
    examples:
      - if (Test-AzCliIsConnected shared_nonprod) { Deploy-Bicep dev sample }
---
#>

function Test-AzCliIsConnected {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription

    Test-AzCliConnected `
        -SubscriptionId $subscriptionDescriptor.id `
        -TenantId $subscriptionDescriptor.tenant.id
}
