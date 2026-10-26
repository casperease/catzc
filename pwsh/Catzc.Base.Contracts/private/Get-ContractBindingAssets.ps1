<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractBindingAssets.ps1.md"
  header: "generated"
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
        elseif ($asset.Version -cne [Catzc.Base.Contracts.ContractLayout]::CurrentVersion -and
            $asset.Direction -eq [Catzc.Base.Contracts.ContractDirection]::Provided) {
            $asset
        }
    }
}
