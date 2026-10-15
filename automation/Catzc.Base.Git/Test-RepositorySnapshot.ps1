<#
.SYNOPSIS
    Returns true when a repository is a test-run snapshot made by New-RepositorySnapshot.
.DESCRIPTION
    Marks a disposable test-run clone: only a snapshot may be deleted, and no generated-file commit happens in one.
    [comment:1](/docs/references/automation/catzc-base-git/Test-RepositorySnapshot.ps1.md#comment1)
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
