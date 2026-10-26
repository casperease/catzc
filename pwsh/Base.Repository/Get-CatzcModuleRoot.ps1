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

    # The module's folder comes from the loaded module, never from its name: the folder drops the namespace the name carries
    # (DDR-TRACK-MODULENAMESPACE).
    $loaded = if ($Module) {
        Get-Module -Name $Module | Select-Object -First 1
    }
    else {
        $PSCmdlet.SessionState.Module
    }
    Assert-NotNull $loaded -ErrorText "Get-CatzcModuleRoot found no loaded module$(if ($Module) { " '$Module'" } else { '; called from outside a module, pass -Module <name>' })."
    $moduleRoot = $loaded.ModuleBase
    $folderName = [System.IO.Path]::GetFileName($moduleRoot)
    $modulesRoot = Get-CatzcModulesRoot
    $isBundled = [System.IO.Path]::GetFullPath([System.IO.Path]::GetDirectoryName($moduleRoot)) -eq [System.IO.Path]::GetFullPath($modulesRoot)
    $overlayRoot = Get-CatzcOverlayRoot
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
