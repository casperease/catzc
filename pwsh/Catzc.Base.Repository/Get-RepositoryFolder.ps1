<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-RepositoryFolder.ps1
    name: get-repository-folder
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
    test: pwsh/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
    docs: "[Get-RepositoryFolder.ps1.md](docs/references/pwsh/catzc-base-repository/Get-RepositoryFolder.ps1.md)"
    cites:
      - ADR-AUTO-PATH-NAMEBYFORM
---
#>

function Get-RepositoryFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Resolve-RepoPath $Path
}
