<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-PWSH-ENUM#3
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#5
      - ADR-REPO-CONTRACT#7
---
#>

<#
.SYNOPSIS
    Lists every contract asset of one unit version folder, with its contract.yml overrides applied.
.DESCRIPTION
    A file at version level, a .frozen in the draft 0.0.0, or a manifest entry naming no asset throws, naming it.
.PARAMETER Unit
    The deployable-unit folder name.
.PARAMETER Version
    The unit's version folder name.
.PARAMETER Folder
    The version folder's absolute path.
.PARAMETER TargetRoot
    The target roots, module name to repository-relative folder. A module it does not name takes the repository root.
.OUTPUTS
    [Catzc.Base.Contracts.ContractAsset[]]
.EXAMPLE
    Get-ContractVersionAsset -Unit widget -Version 0.0.0 -Folder $versionFolder -TargetRoot @{}
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
        [System.Collections.IDictionary] $TargetRoot
    )

    $stray = @([System.IO.Directory]::GetFiles($Folder) |
            ForEach-Object { [System.IO.Path]::GetFileName($_) } |
            Where-Object { $_ -cne 'contract.yml' -and -not ($_ -ceq '.frozen' -and $Version -cne '0.0.0') })
    if ($stray.Count -gt 0) {
        throw "contracts/$Unit/${Version}: '$($stray -join "', '")' sits outside a module folder; an asset lives under contracts/<unit>/<version>/<module>/ (ADR-REPO-CONTRACT#2)."
    }

    $override = (Read-ContractManifest -Folder $Folder).direction
    $used = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $moduleFolders = [string[]] [System.IO.Directory]::GetDirectories($Folder)
    [System.Array]::Sort($moduleFolders, [System.StringComparer]::Ordinal)
    $assets = foreach ($moduleFolder in $moduleFolders) {
        $module = [System.IO.Path]::GetFileName($moduleFolder)
        $root = [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($TargetRoot, $module)
        # A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
        # asset of the version is listed, so no name is pruned and no depth drops one.
        $files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude @() -PruneVendor $false)
        $paths = [string[]] @($files | ForEach-Object { [System.IO.Path]::GetRelativePath($moduleFolder, $_) -replace '\\', '/' })
        [System.Array]::Sort($paths, [System.StringComparer]::Ordinal)
        foreach ($path in $paths) {
            $null = $used.Add("$module/$path")
            Resolve-ContractAsset -Unit $Unit -Version $Version -Module $module -Path $path -File (Join-Path $moduleFolder $path) -TargetRoot $root -Override $override
        }
    }

    $unknown = @($override.Keys | Where-Object { -not $used.Contains($_) } | Sort-Object)
    if ($unknown.Count -gt 0) {
        throw "contracts/$Unit/$Version/contract.yml: the direction of '$($unknown -join "', '")' is overridden, but no such asset exists under the version folder (ADR-REPO-CONTRACT#7)."
    }
    $assets
}
