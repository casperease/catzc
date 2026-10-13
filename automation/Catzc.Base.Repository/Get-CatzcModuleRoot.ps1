<#
.SYNOPSIS
    Returns a module's own folder inside the loaded catzc code tree, optionally joined with a child path.
.DESCRIPTION
    The one sanctioned way for module code to locate content that ships with it — its configs/ and assets/, or
    another module's (ADR-AUTO-ASSETDEP:1). Resolves against Get-CatzcModulesRoot, so the answer is correct in
    both run modes (ADR-DSGN-RUNMODE): <RepositoryRoot>/automation/<Module> in source mode, and
    <build>/<version>/<Module> in build mode, where the merged <Module>.ps1 sits beside the same configs/ and
    assets/ folders.

    -Module defaults to the module of the calling function, so module code writes only the child path. Pass
    -ChildPath as a string literal at every call site: Get-InternalAssetDependency derives the inventory of
    internal asset dependencies from those literals (ADR-AUTO-ASSETDEP:2).

    Asserts the module folder exists; the child path is not asserted, so a caller may name a file it is about to
    create, or test for an optional one.
.PARAMETER ChildPath
    A path below the module folder, '/'-separated (e.g. 'assets/gitkeep', 'configs/configs.yml'). Omit for the
    module folder itself.
.PARAMETER Module
    The module whose folder to resolve. Defaults to the module of the calling function; required when called
    from outside a module (a script or the console).
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
    Assert-PathExist $moduleRoot -PathType Container

    if (-not $ChildPath) {
        return $moduleRoot
    }
    Join-Path $moduleRoot $ChildPath
}
