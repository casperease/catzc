<#
---
catzc:
  immutable:
    with_body_sha: "2e8821c4771a"
  edges:
    docs: "[Get-ContractBindingAssets.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractBindingAssets.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-KEPTWHILEPINNED
      - ADR-REPO-CONTRACT-PROVENBYTESTS
---
#>

function Get-ContractBindingAssets {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+$')]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    foreach ($asset in Get-Contract -Version '*' -RepositoryRoot $RepositoryRoot) {
        if ($asset.Version -ceq $Version) {
            $asset
        }
        elseif ($asset.Version -cne '0.0.0' -and $asset.Direction -eq [Catzc.Base.Contracts.ContractDirection]::Provided) {
            $asset
        }
    }
}
