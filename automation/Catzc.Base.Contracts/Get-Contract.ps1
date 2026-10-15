<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/Get-Contract.ps1
    kind: automation-function
    module: Catzc.Base.Contracts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
    adrs:
      - ADR-AUTO-PATH#2
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-CONTRACT#7
      - ADR-REPO-CONTRACT#8
  config:
    synopsis: Lists the repository's contract assets, with every fact derived from each asset's name.
    description: |-
      Enumerates contracts/<unit>/<version>/<module>/<path>
      ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)) and returns one ContractAsset per
      file under a module folder. Nothing is registered: the unit, version, and owning module come from the folders; the
      kind from the file name ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)); the target
      from the path under the module, placed under the module's target root (the repository root unless contracts.yml's
      target_roots names one); and the direction from the convention, which a version's contract.yml overrides
      for a single asset ([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)). Every path is in
      communication form ([ADR-AUTO-PATH#2](/docs/adr/automation/path-representation.md#rule-adr-auto-path2)).

      It lists and derives only: it never reads the real files the assets constrain. Files directly under contracts/ (its
      README) are not assets, and neither is a released version folder's .frozen record
      ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)). A version folder whose name is not <major>.<minor>.<patch>, a file outside a module folder,
      and a contract.yml entry naming no asset each throw. A missing or empty contracts/ gives an empty result.

      The addressing mode decides how an asset addresses files
      ([ADR-REPO-CONTRACT#8](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract8)); only full-path is built, and
      selecting a declared mode that is not built throws NotImplementedException before anything is enumerated.
    parameters:
      Unit: 'The deployable-units to list, by folder name; wildcards allowed. Default: every unit.'
      Version: 'The unit versions to list, by folder name; wildcards allowed. Default: 0.0.0, each unit''s draft.'
      Module: 'The owning modules to list; wildcards allowed. Default: every module.'
      Path: 'Keeps the assets whose path under the module, or whose target, matches; wildcards allowed. Default: every asset.'
      Addressing: 'How an asset addresses many files. Default: contracts.yml''s addressing.'
      TargetRoot: |-
        Each owning module's target root, module name to repository-relative folder; a module it does not name takes the
        repository root. Default: contracts.yml's target_roots.
      RepositoryRoot: 'The repository root that holds contracts/. Default: the loaded repository root.'
    outputs: '[Catzc.Base.Contracts.ContractAsset[]] in ordinal order of unit, version, module, then path.'
    examples:
      - Get-Contract
      - Get-Contract -Unit catzc -Version *
      - Get-Contract -Path .github/workflows/*
---
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
