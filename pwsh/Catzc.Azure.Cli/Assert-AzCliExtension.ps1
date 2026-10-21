<#
---
catzc:
  immutable:
    with_body_sha: "06dc02005aed"
  edges:
    docs: "[Assert-AzCliExtension.ps1.md](../../docs/references/pwsh/catzc-azure-cli/Assert-AzCliExtension.ps1.md)"
---
#>

function Assert-AzCliExtension {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    if (-not (Test-AzCliExtension -Name $Name)) {
        throw "The Azure CLI extension '$Name' is required but not installed. Install it with: az extension add --name $Name (add --allow-preview true if only a preview version exists)."
    }
}
