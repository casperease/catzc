<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-contracts/Get-Contract.ps1.md"
  header: "generated"
---
#>

function Get-Contract {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string[]] $Root = '*',

        [SupportsWildcards()]
        [string[]] $Version = '0.1.0',

        [SupportsWildcards()]
        [string[]] $Group = '*',

        [SupportsWildcards()]
        [string[]] $Path = '*',

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $contractsRoot = Join-Path $RepositoryRoot 'contracts'
    if (-not [System.IO.Directory]::Exists($contractsRoot)) {
        Write-Verbose "Get-Contract: no contracts folder at '$contractsRoot'."
        return
    }

    $rootFolders = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk)).Folders($contractsRoot)
    foreach ($rootFolder in $rootFolders) {
        $rootName = [System.IO.Path]::GetFileName($rootFolder)
        if (@($Root | Where-Object { $rootName -like $_ }).Count -eq 0) {
            continue
        }
        foreach ($asset in Get-ContractRootAsset -Root $rootName -Folder $rootFolder -Version $Version -RepositoryRoot $RepositoryRoot) {
            $isGroup = @($Group | Where-Object { $asset.Group -like $_ }).Count -gt 0
            $isPath = @($Path | Where-Object { $asset.Path -like $_ -or ($null -ne $asset.Target -and
                $asset.Target -like $_) }).Count -gt 0
            if ($isGroup -and $isPath) {
                $asset
            }
        }
    }
}
