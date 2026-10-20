<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-RepositoryRoot.ps1
    name: get-repository-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-RepositoryRoot.Tests.ps1
    docs: "[Get-RepositoryRoot.ps1.md](docs/references/pwsh/catzc-base-repository/Get-RepositoryRoot.ps1.md)"
---
#>

function Get-RepositoryRoot {
    param()

    $env:RepositoryRoot
}
