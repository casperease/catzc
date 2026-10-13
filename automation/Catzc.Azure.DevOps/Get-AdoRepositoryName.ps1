<#
.SYNOPSIS
    The Azure DevOps repository this checkout is: the sensible default for every -RepositoryName.
.DESCRIPTION
    In a pipeline, the agent's own repository ($env:BUILD_REPOSITORY_NAME); on a devbox, the checkout folder's
    name (the leaf of Get-RepositoryRoot), which is the repository's name in a default clone. The one place the
    ADO functions derive the name, declared as their -RepositoryName default
    ([ADR-AUTO-PSPARAM#4](/docs/adr/automation/powershell/parameter-design.md#rule-adr-auto-psparam4)), so an
    explicit argument always wins and Get-Help shows where the default comes from.
.OUTPUTS
    [string] The repository name.
.EXAMPLE
    Get-AdoRepositoryName
#>
function Get-AdoRepositoryName {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ($env:BUILD_REPOSITORY_NAME) {
        return $env:BUILD_REPOSITORY_NAME
    }
    Split-Path (Get-RepositoryRoot) -Leaf
}
