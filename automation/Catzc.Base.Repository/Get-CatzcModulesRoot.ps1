<#
.SYNOPSIS
    Returns the root of the catzc automation tree — the folder that holds the loaded modules.
.DESCRIPTION
    Differs from the repository root only in an install, where the code lives in the bundle, not the working root.
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
