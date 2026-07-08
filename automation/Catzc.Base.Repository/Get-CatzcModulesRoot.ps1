<#
.SYNOPSIS
    Returns the root of the catzc automation tree — the folder that holds the loaded modules.
.DESCRIPTION
    Returns $env:CatzcModulesRoot, the well-known anchor the importer sets to the automation/ directory holding
    the running catzc modules. In the mono repo this is <RepositoryRoot>/automation; in an installed bundle it
    is the bundle's own automation/, so config, type and vendor discovery follow the code wherever it is
    installed instead of assuming it sits under the working RepositoryRoot.

    Distinct from Get-RepositoryRoot: RepositoryRoot is the working root (where out/ goes, what repo-relative
    paths and git resolve against); CatzcModulesRoot is where catzc's own code lives. The two coincide in the
    mono repo and diverge only in an install. Falls back to <RepositoryRoot>/automation when the anchor is not
    set — a module imported without the importer — so behaviour is unchanged when nothing set the anchor.
.EXAMPLE
    Get-CatzcModulesRoot
#>
function Get-CatzcModulesRoot {
    param()

    if ($env:CatzcModulesRoot) {
        return $env:CatzcModulesRoot
    }

    Join-Path (Get-RepositoryRoot) 'automation'
}
