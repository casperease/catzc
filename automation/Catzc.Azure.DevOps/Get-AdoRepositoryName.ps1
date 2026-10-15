<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1
    kind: function
    module: Catzc.Azure.DevOps
    visibility: public
---
#>

<#
.SYNOPSIS
    The Azure DevOps repository this checkout is: the sensible default for every -RepositoryName.
.DESCRIPTION
    The checkout folder name equals the repository name only in a default clone, so an explicit argument wins.
    [ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)
    [comment:1](/docs/references/automation/catzc-azure-devops/Get-AdoRepositoryName.ps1.md#comment1)
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
