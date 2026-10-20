<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps/Get-AdoRepositoryName.ps1
    name: get-ado-repository-name
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Get-AdoRepositoryName.Tests.ps1
    docs: "[Get-AdoRepositoryName.ps1.md](docs/references/pwsh/catzc-azure-devops/Get-AdoRepositoryName.ps1.md)"
    cites:
      - ADR-PWSH-PARAM-RESOLUTIONORDER
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
