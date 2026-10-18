<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1
    name: get-ado-repository-name
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.DevOps/tests/Get-AdoRepositoryName.Tests.ps1
    cites:
      - ADR-PWSH-PARAM#4
---
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
