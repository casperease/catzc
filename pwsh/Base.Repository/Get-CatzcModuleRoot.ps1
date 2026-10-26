<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-CatzcModuleRoot.ps1.md"
  header: "generated"
---
#>

function Get-CatzcModuleRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string] $ChildPath,

        [string] $Module
    )

    # The folder comes from the loaded module, never its name, which carries the namespace the folder drops.
    $loaded = if ($Module) {
        Get-Module -Name $Module | Select-Object -First 1
    }
    else {
        $PSCmdlet.SessionState.Module
    }
    Assert-NotNull $loaded -ErrorText "Get-CatzcModuleRoot found no loaded module$(if ($Module) { " '$Module'" } else { '; called from outside a module, pass -Module <name>' })."
    $moduleRoot = $loaded.ModuleBase
    $overlayRoot = Get-CatzcOverlayRoot
    # A consumer's local module is a dynamic module with no file, named for its overlay folder (it carries no namespace).
    if (-not [System.IO.File]::Exists($loaded.Path) -and $overlayRoot -and [System.IO.Directory]::Exists([System.IO.Path]::Combine($overlayRoot, $loaded.Name))) {
        $moduleRoot = [System.IO.Path]::Combine($overlayRoot, $loaded.Name)
    }
    $folderName = [System.IO.Path]::GetFileName($moduleRoot)
    $modulesRoot = Get-CatzcModulesRoot
    $isBundled = [System.IO.Path]::GetFullPath([System.IO.Path]::GetDirectoryName($moduleRoot)) -eq [System.IO.Path]::GetFullPath($modulesRoot)
    Assert-PathExist $moduleRoot -PathType Container

    if (-not $ChildPath) {
        return $moduleRoot
    }
    if ($isBundled -and $overlayRoot -and $ChildPath.Replace('\', '/').StartsWith('assets/',
            [System.StringComparison]::Ordinal)) {
        $override = [System.IO.Path]::Combine($overlayRoot, $folderName, $ChildPath)
        if ([System.IO.File]::Exists($override)) {
            return $override
        }
    }
    Join-Path $moduleRoot $ChildPath
}
