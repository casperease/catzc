<#
---
catzc:
  immutable:
    with_body_sha: "14c341b204d5"
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
    docs: "[Get-RepositoryFolder.ps1.md](../../docs/references/pwsh/catzc-base-repository/Get-RepositoryFolder.ps1.md)"
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
