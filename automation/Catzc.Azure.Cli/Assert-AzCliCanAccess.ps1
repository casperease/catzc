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
