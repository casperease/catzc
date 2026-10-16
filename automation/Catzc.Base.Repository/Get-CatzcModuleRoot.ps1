<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Repository
    visibility: public
    relatives:
      test: automation/Catzc.Base.Repository/tests/Get-CatzcModuleRoot.Tests.ps1
    adrs:
      - ADR-AUTO-ASSETDEP#{1,2}
      - ADR-AUTO-OVERLAY
      - ADR-DSGN-RUNMODE
  config:
    synopsis: Returns a module's own folder inside the loaded catzc code tree, optionally joined with a child path.
    description: |-
      The one sanctioned way for module code to locate content that ships with it — its configs/ and assets/, or
      another module's
      ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)). Resolves
      against Get-CatzcModulesRoot, so the answer is correct in
      both run modes
      ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): <RepositoryRoot>/automation/<Module> in source mode, and
      <build>/<version>/<Module> in build mode, where the merged <Module>.ps1 sits beside the same configs/ and
      assets/ folders.

      -Module defaults to the module of the calling function, so module code writes only the child path. Pass
      -ChildPath as a string literal at every call site: Get-InternalAssetDependency derives the inventory of
      internal asset dependencies from those literals
      ([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)).

      Asserts the module folder exists; the child path is not asserted, so a caller may name a file it is about to
      create, or test for an optional one.

      In build mode a consumer overlay may replace a module's asset: when <overlay root>/<Module>/<ChildPath> is a
      file under assets/, that path is returned instead of the bundled one
      ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). Only assets/ is looked up there — configs merge
      through Get-Config, and the registry and other module files are never replaced wholesale. A consumer's local
      module — an overlay folder that names no bundled module — resolves to its overlay folder.
    parameters:
      ChildPath: |-
        A path below the module folder, '/'-separated (e.g. 'assets/gitkeep', 'configs/configs.yml'). Omit for the
        module folder itself.
      Module: |-
        The module whose folder to resolve. Defaults to the module of the calling function; required when called
        from outside a module (a script or the console).
    examples:
      - Get-CatzcModuleRoot 'assets/gitkeep'
      - Get-CatzcModuleRoot 'configs/configs.yml' -Module Catzc.Base.Config
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
