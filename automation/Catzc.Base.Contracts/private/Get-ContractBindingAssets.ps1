<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractBindingAssets.ps1
    kind: private-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#3
      - ADR-REPO-CONTRACT#4
---
#>

<#
.SYNOPSIS
    Lists the contract assets the repository must honour now: every asset of the current version folder, and the
    provided assets of every released version folder still in the tree.
.DESCRIPTION
    Depended-on assets of older releases are skipped: they follow their outside platform, so only the current binds.
.PARAMETER Version
    The current version folder of every unit, <major>.<minor>.<patch>.
.PARAMETER RepositoryRoot
    The repository root that holds contracts/.
.OUTPUTS
    [Catzc.Base.Contracts.ContractAsset[]] In Get-Contract's ordinal order of unit, version, module, then path.
.EXAMPLE
    Get-ContractBindingAssets -Version 0.0.0 -RepositoryRoot $root
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
