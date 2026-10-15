# catzc:
#   path: automation/Catzc.Base.Repository/Get-RepositoryRoot.ps1
#   module: Catzc.Base.Repository
#   visibility: public

<#
.SYNOPSIS
    Returns the repository root path.
.DESCRIPTION
    Returns the value of $env:RepositoryRoot set by importer.ps1.
.EXAMPLE
    Get-RepositoryRoot
#>
function Get-RepositoryRoot {
    param()

    $env:RepositoryRoot
}
