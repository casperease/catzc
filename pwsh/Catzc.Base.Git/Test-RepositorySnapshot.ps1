<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Git/Test-RepositorySnapshot.ps1
    name: test-repository-snapshot
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Git/tests/Test-RepositorySnapshot.Tests.ps1
    docs: "[Test-RepositorySnapshot.ps1.md](docs/references/pwsh/catzc-base-git/Test-RepositorySnapshot.ps1.md)"
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
