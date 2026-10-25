<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md"
  header: "generated"
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
        [string] $RepositoryRoot,

        [string] $Addressing = [Catzc.Base.Contracts.ContractsConfig]::DefaultAddressing
    )

    $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
    $stray = @($layout.FileNames($Folder) |
            Where-Object { $_ -cne 'contract.yml' -and -not ($_ -ceq '.frozen' -and $Version -cne '0.0.0') })
    if ($stray.Count -gt 0) {
        throw "contracts/$Unit/${Version}: '$($stray -join "', '")' sits outside a module folder; an asset lives under contracts/<unit>/<version>/<module>/ (ADR-REPO-CONTRACT-LAYOUT)."
    }

    $manifest = Read-ContractManifest -Folder $Folder
    $override = $manifest.direction
    $appliesTo = $manifest.applies_to
    if ($appliesTo.Count -gt 0 -and $Addressing -cne 'manifest-glob') {
        throw "contracts/$Unit/$Version/contract.yml: applies_to addresses many files, which the '$Addressing' addressing mode does not read; set addressing: manifest-glob in contracts.yml (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
    # The tracked files are listed only once an asset asks for its globs to be matched: nothing is enumerated speculatively.
    $tracked = $null
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
            $asset = Resolve-ContractAsset -Unit $Unit -Version $Version -Module $module -Path $path -File (Join-Path $moduleFolder $path) -TargetRoot $root -Override $override -CommandRoot $commandRoot
            if (-not $appliesTo.ContainsKey("$module/$path")) {
                $asset
                continue
            }
            if ($asset.Kind -notin [Catzc.Base.Contracts.ContractAssetKind]::Schema, [Catzc.Base.Contracts.ContractAssetKind]::Fragment, [Catzc.Base.Contracts.ContractAssetKind]::Presence) {
                throw "contracts/$Unit/$Version/contract.yml: applies_to names '$module/$path', a $($asset.Kind) asset; only a schema, fragment or presence asset constrains files (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
            }
            if ($null -eq $tracked) {
                $tracked = [string[]] @(Get-GitTrackedPath '.')
            }
            $prefix = if ($root) {
                "$root/"
            }
            else {
                ''
            }
            $globs = [string[]] @($appliesTo["$module/$path"] | ForEach-Object { "$prefix$_" })
            $targets = [Catzc.Base.Globs.GlobPattern]::MatchingPaths($globs, $tracked)
            if ($targets.Count -eq 0) {
                throw "contracts/$Unit/$Version/contract.yml: applies_to of '$module/$path' matches no tracked file ($($globs -join ', ')) (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
            }
            foreach ($target in $targets) {
                [Catzc.Base.Contracts.ContractAsset]::new($asset.Unit, $asset.Version, $asset.Module, $asset.Path, $asset.Kind, $target, $asset.Direction, $asset.IsDirectionOverridden)
            }
        }
    }

    $unknown = @($override.Keys | Where-Object { -not $used.Contains($_) } | Sort-Object)
    if ($unknown.Count -gt 0) {
        throw "contracts/$Unit/$Version/contract.yml: the direction of '$($unknown -join "', '")' is overridden, but no such asset exists under the version folder (ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION)."
    }
    $unaddressed = @($appliesTo.Keys | Where-Object { -not $used.Contains($_) } | Sort-Object)
    if ($unaddressed.Count -gt 0) {
        throw "contracts/$Unit/$Version/contract.yml: applies_to names '$($unaddressed -join "', '")', but no such asset exists under the version folder (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING)."
    }
    $assets
}
