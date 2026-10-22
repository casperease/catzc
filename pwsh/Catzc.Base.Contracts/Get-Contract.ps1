<#
---
catzc:
  immutable:
    with_body_sha: "98d4ff59df79"
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
    docs: "[Get-Contract.ps1.md](../../docs/references/pwsh/catzc-base-contracts/Get-Contract.ps1.md)"
    cites:
      - ADR-AUTO-PATH-COMMUNICATIONFORM
      - ADR-REPO-CONTRACT-LAYOUT
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
      - ADR-REPO-CONTRACT-CONTRACTASSET
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
      - ADR-REPO-CONTRACT-CONFIGUREDADDRESSING
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
        throw [System.NotImplementedException]::new("Get-Contract: the addressing mode '$Addressing' is declared but not built yet; the built modes are: $([Catzc.Base.Contracts.ContractsConfig]::BuiltAddressingModes -join ', '). A mode is switched on only once it is proven from both pwsh and bash (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING).")
    }

    $contractsRoot = Join-Path $RepositoryRoot 'contracts'
    if (-not [System.IO.Directory]::Exists($contractsRoot)) {
        Write-Verbose "Get-Contract: no contracts folder at '$contractsRoot'."
        return
    }

    $unitFolders = [Catzc.Base.Folders.FolderWalker]::Walk($contractsRoot, 1, [string[]] '*', $false, $true, $null)
    foreach ($unitFolder in $unitFolders) {
        $unitName = [System.IO.Path]::GetFileName($unitFolder)
        if (@($Unit | Where-Object { $unitName -like $_ }).Count -eq 0) {
            continue
        }
        foreach ($asset in Get-ContractUnitAsset -Unit $unitName -Folder $unitFolder -Version $Version -TargetRoot $TargetRoot -RepositoryRoot $RepositoryRoot) {
            $isModule = @($Module | Where-Object { $asset.Module -like $_ }).Count -gt 0
            $isPath = @($Path | Where-Object { $asset.Path -like $_ -or ($null -ne $asset.Target -and $asset.Target -like $_) }).Count -gt 0
            if ($isModule -and $isPath) {
                $asset
            }
        }
    }
}
