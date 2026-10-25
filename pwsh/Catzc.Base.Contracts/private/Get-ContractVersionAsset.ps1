<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md"
  warning: "Generated Header"
---
#>

function Get-ContractVersionAsset {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Unit,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $Folder,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $TargetRoot,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
    $stray = @($layout.FileNames($Folder) |
            Where-Object { $_ -cne 'contract.yml' -and -not ($_ -ceq '.frozen' -and $Version -cne '0.0.0') })
    if ($stray.Count -gt 0) {
        throw "contracts/$Unit/${Version}: '$($stray -join "', '")' sits outside a module folder; an asset lives under contracts/<unit>/<version>/<module>/ (ADR-REPO-CONTRACT-LAYOUT)."
    }

    $override = (Read-ContractManifest -Folder $Folder).direction
    $normalForm = (Get-Config -Config languages).naming_normal_form
    $used = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $moduleFolders = $layout.Folders($Folder)
    $assets = foreach ($moduleFolder in $moduleFolders) {
        $module = [System.IO.Path]::GetFileName($moduleFolder)
        # target_roots names a module in the normal form; a unit that keeps its source's folder names is looked up by its rendering.
        $key = $module
        if ([Catzc.Base.Objects.NameCase]::IsInCase('pascal-dotted', $module)) {
            $key = [Catzc.Base.Objects.NameCase]::ToNormal('pascal-dotted', $module, $normalForm)
        }
        $root = [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($TargetRoot, $key)
        $files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude @() -PruneVendor $false)
        $paths = [string[]] @($files | ForEach-Object { [System.IO.Path]::GetRelativePath($moduleFolder, $_) -replace '\\', '/' })
        [System.Array]::Sort($paths, [System.StringComparer]::Ordinal)
        $commandRoot = $null
        foreach ($path in $paths) {
            $null = $used.Add("$module/$path")
            $leaf = $path.Substring($path.LastIndexOf('/') + 1)
            if (-not $commandRoot -and (Get-ContractAssetKind -Name $leaf) -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
                $commandRoot = Get-ContractCommandRoot -Module $module -RepositoryRoot $RepositoryRoot
            }
            Resolve-ContractAsset -Unit $Unit -Version $Version -Module $module -Path $path -File (Join-Path $moduleFolder $path) -TargetRoot $root -Override $override -CommandRoot $commandRoot
        }
    }

    $unknown = @($override.Keys | Where-Object { -not $used.Contains($_) } | Sort-Object)
    if ($unknown.Count -gt 0) {
        throw "contracts/$Unit/$Version/contract.yml: the direction of '$($unknown -join "', '")' is overridden, but no such asset exists under the version folder (ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION)."
    }
    $assets
}
