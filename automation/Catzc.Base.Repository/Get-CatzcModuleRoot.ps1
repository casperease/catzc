<#
.SYNOPSIS
    Returns a module's own folder inside the loaded catzc code tree, optionally joined with a child path.
.DESCRIPTION
    The one sanctioned way for module code to locate content that ships with it — its configs/ and assets/, or...
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1),
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md),
    [ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2),
    [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md#comment1)
.PARAMETER ChildPath
    A path below the module folder, '/'-separated (e.g.
    [comment:2](/docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md#comment2)
.PARAMETER Module
    The module whose folder to resolve.
    [comment:3](/docs/references/automation/catzc-base-repository/Get-CatzcModuleRoot.ps1.md#comment3)
.EXAMPLE
    Get-CatzcModuleRoot 'assets/gitkeep'
.EXAMPLE
    Get-CatzcModuleRoot 'configs/configs.yml' -Module Catzc.Base.Config
#>
function Get-CatzcModuleRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string] $ChildPath,

        [string] $Module
    )

    $moduleName = $Module
    if (-not $moduleName) {
        $callerModule = $PSCmdlet.SessionState.Module
        Assert-NotNull $callerModule -ErrorText 'Get-CatzcModuleRoot was called from outside a module; pass -Module <name>.'
        $moduleName = $callerModule.Name
    }

    $moduleRoot = Join-Path (Get-CatzcModulesRoot) $moduleName
    $isBundled = [System.IO.Directory]::Exists($moduleRoot)
    $overlayRoot = Get-CatzcOverlayRoot
    if (-not $isBundled -and $overlayRoot -and [System.IO.Directory]::Exists([System.IO.Path]::Combine($overlayRoot, $moduleName))) {
        # A consumer's local module: its folder is the overlay's, and nothing there overrides it.
        $moduleRoot = [System.IO.Path]::Combine($overlayRoot, $moduleName)
    }
    Assert-PathExist $moduleRoot -PathType Container

    if (-not $ChildPath) {
        return $moduleRoot
    }
    if ($isBundled -and $overlayRoot -and $ChildPath.Replace('\', '/').StartsWith('assets/', [System.StringComparison]::Ordinal)) {
        $override = [System.IO.Path]::Combine($overlayRoot, $moduleName, $ChildPath)
        if ([System.IO.File]::Exists($override)) {
            return $override
        }
    }
    Join-Path $moduleRoot $ChildPath
}
