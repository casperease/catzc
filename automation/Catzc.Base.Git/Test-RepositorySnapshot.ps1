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
  config:
    synopsis: Returns true when a repository is a test-run snapshot made by New-RepositorySnapshot.
    description: |-
      The one reader of the snapshot provenance marker (.git/catzc-snapshot.json) that New-RepositorySnapshot
      writes. A snapshot is a disposable clone a test run executes in: Remove-RepositorySnapshot deletes only a
      snapshot, and the importer's generated-file commit never commits inside one.
    parameters:
      Path: 'The repository root to check. Default: the loaded repository root.'
    outputs: '[bool]'
    examples:
      - Test-RepositorySnapshot
      - Test-RepositorySnapshot 'C:\Temp\catzc-run-0f3a'
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
