<#
---
catzc:
  immutable:
    with_body_sha: "9414acebc0b1"
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliSubscriptionAccessible.Tests.ps1
    docs: "[Test-AzCliSubscriptionAccessible.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md)"
    cites:
      - ADR-AZ-CLI-AZBYDEFAULT
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
