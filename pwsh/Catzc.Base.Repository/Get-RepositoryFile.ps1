<#
---
catzc:
  immutable:
    with_body_sha: "336cbd44cf9c"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
    docs: "[Get-RepositoryFile.ps1.md](../../docs/references/pwsh/catzc-base-repository/Get-RepositoryFile.ps1.md)"
    cites:
      - ADR-AUTO-PATH-NAMEBYFORM
---
#>

function Get-RepositoryFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Resolve-RepoPath $Path
}
