<#
---
catzc:
  immutable:
    with_body_sha: c034ed98a5e3
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
