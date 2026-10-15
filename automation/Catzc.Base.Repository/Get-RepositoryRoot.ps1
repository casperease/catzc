<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-RepositoryRoot.ps1
    kind: public-function
    module: Catzc.Base.Repository
    visibility: public
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
