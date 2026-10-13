<#
.SYNOPSIS
    Returns true when a repository is a test-run snapshot made by New-RepositorySnapshot.
.DESCRIPTION
    The one reader of the snapshot provenance marker (.git/catzc-snapshot.json) that New-RepositorySnapshot
    writes. A snapshot is a disposable clone a test run executes in: Remove-RepositorySnapshot deletes only a
    snapshot, and the importer's generated-file commit never commits inside one.
.PARAMETER Path
    The repository root to check. Default: the loaded repository root.
.OUTPUTS
    [bool]
.EXAMPLE
    Test-RepositorySnapshot
.EXAMPLE
    Test-RepositorySnapshot 'C:\Temp\catzc-run-0f3a'
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
