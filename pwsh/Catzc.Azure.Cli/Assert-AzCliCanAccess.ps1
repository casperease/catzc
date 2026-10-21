<#
---
catzc:
  immutable:
    with_body_sha: "3fb39c5d5891"
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Assert-AzCliCanAccess.Tests.ps1
    docs: "[Assert-AzCliCanAccess.ps1.md](../../docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md)"
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
