<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/Test-RepositorySnapshot.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Git
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
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
