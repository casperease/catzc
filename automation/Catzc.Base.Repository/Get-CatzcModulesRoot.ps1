<#
.SYNOPSIS
    Returns the root of the catzc automation tree — the folder that holds the loaded modules.
.DESCRIPTION
    Returns $env:CatzcModulesRoot, the well-known anchor the importer sets to the automation/ directory holding the...
    [comment:1](/docs/references/automation/catzc-base-repository/Get-CatzcModulesRoot.ps1.md#comment1)
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
