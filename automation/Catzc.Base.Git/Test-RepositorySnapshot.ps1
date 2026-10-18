<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/Test-RepositorySnapshot.ps1
    name: test-repository-snapshot
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Git/tests/Test-RepositorySnapshot.Tests.ps1
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
