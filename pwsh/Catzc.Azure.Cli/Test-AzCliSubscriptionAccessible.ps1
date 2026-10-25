<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md"
  header: "generated"
---
#>

function Test-AzCliSubscriptionAccessible {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    (Get-AzCliSubscriptionAccessState $SubscriptionId).accessible
}
