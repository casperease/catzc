<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1
    name: get-repository-folder
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
    cites:
      - ADR-AUTO-PATH#7
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
