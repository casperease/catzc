<#
---
catzc:
  immutable:
    with_body_sha: "9eab36e7509e"
  edges:
    test: pwsh/Catzc.Base.Git/tests/Test-RepositorySnapshot.Tests.ps1
    docs: "[Test-RepositorySnapshot.ps1.md](../../docs/references/pwsh/catzc-base-git/Test-RepositorySnapshot.ps1.md)"
---
#>

function Test-RepositorySnapshot {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0)]
        [string] $Path = (Get-RepositoryRoot)
    )

    [System.IO.File]::Exists((Join-Path $Path '.git/catzc-snapshot.json'))
}
