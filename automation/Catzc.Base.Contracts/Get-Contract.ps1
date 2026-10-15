<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/Get-Contract.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: public
    adrs:
      - ADR-AUTO-PATH#2
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-CONTRACT#7
      - ADR-REPO-CONTRACT#8
---
#>

<#
.SYNOPSIS
    Lists the repository's contract assets, with every fact derived from each asset's name.
.DESCRIPTION
    Nothing is registered: every fact comes from folder and file names, and the real files are never read.
    [comment:1](/docs/references/automation/catzc-base-contracts/Get-Contract.ps1.md#comment1)
.PARAMETER Unit
    The deployable-units to list, by folder name; wildcards allowed. Default: every unit.
.PARAMETER Version
    The unit versions to list, by folder name; wildcards allowed. Default: 0.0.0, each unit's draft.
.PARAMETER Module
    The owning modules to list; wildcards allowed. Default: every module.
.PARAMETER Path
    Keeps the assets whose path under the module, or whose target, matches; wildcards allowed. Default: every asset.
.PARAMETER Addressing
    How an asset addresses many files. Default: contracts.yml's addressing.
.PARAMETER TargetRoot
    A module the map does not name takes the repository root, so an empty map puts every target at the root.
    [comment:2](/docs/references/automation/catzc-base-contracts/Get-Contract.ps1.md#comment2)
.PARAMETER RepositoryRoot
    The repository root that holds contracts/. Default: the loaded repository root.
.OUTPUTS
    [Catzc.Base.Contracts.ContractAsset[]] in ordinal order of unit, version, module, then path.
.EXAMPLE
    Get-Contract
.EXAMPLE
    Get-Contract -Unit catzc -Version *
.EXAMPLE
    Get-Contract -Path .github/workflows/*
#>
function Get-Contract {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string[]] $Unit = '*',

        [SupportsWildcards()]
        [string[]] $Version = '0.0.0',

        [SupportsWildcards()]
        [string[]] $Module = '*',

        [SupportsWildcards()]
        [string[]] $Path = '*',

        [string] $Addressing = (Get-Config -Config contracts).addressing,

        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $TargetRoot = (Get-Config -Config contracts).target_roots,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    if ($Addressing -cnotin [Catzc.Base.Contracts.ContractsConfig]::AddressingModes) {
        throw [System.ArgumentException]::new("Get-Contract: addressing '$Addressing' is not one of: $([Catzc.Base.Contracts.ContractsConfig]::AddressingModes -join ', ').")
    }
    if ($Addressing -cnotin [Catzc.Base.Contracts.ContractsConfig]::BuiltAddressingModes) {
        throw [System.NotImplementedException]::new("Get-Contract: the addressing mode '$Addressing' is declared but not built yet; the built modes are: $([Catzc.Base.Contracts.ContractsConfig]::BuiltAddressingModes -join ', '). A mode is switched on only once it is proven from both pwsh and bash (ADR-REPO-CONTRACT#8).")
    }

    $contractsRoot = Join-Path $RepositoryRoot 'contracts'
    if (-not [System.IO.Directory]::Exists($contractsRoot)) {
        Write-Verbose "Get-Contract: no contracts folder at '$contractsRoot'."
        return
    }

    $unitFolders = [string[]] [System.IO.Directory]::GetDirectories($contractsRoot)
    [System.Array]::Sort($unitFolders, [System.StringComparer]::Ordinal)
    foreach ($unitFolder in $unitFolders) {
        $unitName = [System.IO.Path]::GetFileName($unitFolder)
        if (@($Unit | Where-Object { $unitName -like $_ }).Count -eq 0) {
            continue
        }
        foreach ($asset in Get-ContractUnitAsset -Unit $unitName -Folder $unitFolder -Version $Version -TargetRoot $TargetRoot) {
            $isModule = @($Module | Where-Object { $asset.Module -like $_ }).Count -gt 0
            $isPath = @($Path | Where-Object { $asset.Path -like $_ -or ($null -ne $asset.Target -and $asset.Target -like $_) }).Count -gt 0
            if ($isModule -and $isPath) {
                $asset
            }
        }
    }
}
