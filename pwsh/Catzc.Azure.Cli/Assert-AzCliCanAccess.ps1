<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
    name: assert-az-cli-can-access
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Assert-AzCliCanAccess.Tests.ps1
    docs: "[Assert-AzCliCanAccess.ps1.md](docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md)"
    cites:
      - ADR-AZ-CLI-AZBYDEFAULT
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
