<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
    name: get-catzc-module-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Repository/tests/Get-CatzcModuleRoot.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#{1,2}
      - ADR-AUTO-OVERLAY
      - ADR-DSGN-RUNMODE
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
