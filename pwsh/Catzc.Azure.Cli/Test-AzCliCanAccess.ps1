<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
    name: test-az-cli-can-access
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliCanAccess.Tests.ps1
    docs: "[Test-AzCliCanAccess.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliCanAccess.ps1.md)"
    cites:
      - ADR-AZ-CLI-AZBYDEFAULT
      - ADR-AZ-DATAMOD
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
