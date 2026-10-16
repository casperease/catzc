<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-RepositoryRoot.ps1
    name: get-repository-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Repository/tests/Get-RepositoryRoot.Tests.ps1
  config:
    synopsis: Returns the repository root path.
    description: Returns the value of $env:RepositoryRoot set by importer.ps1.
    examples:
      - Get-RepositoryRoot
---
#>

function Get-RepositoryRoot {
    param()

    $env:RepositoryRoot
}
