# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Write-TestRunLockRecord.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Writes the record that names who holds a test-run lock.
.DESCRIPTION
    The lock says only that it is held, so this record names the holder and a blocked run need not guess.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestRunLockRecord.ps1.md#comment1)
.PARAMETER Path
    The record file. Its folder is created when missing.
.PARAMETER EntryPoint
    The entry point holding the lock ('Test-Automation', 'Invoke-TestFile', …).
.PARAMETER RunDirectory
    The holder's run folder.
.PARAMETER RepositoryRoot
    The holder's working folder — what tells two checkouts apart for a user-wide lock.
.OUTPUTS
    None.
.EXAMPLE
    Write-TestRunLockRecord -Path $lockPath -EntryPoint 'Test-Automation' -RunDirectory $runDir -RepositoryRoot $root
#>
function Write-TestRunLockRecord {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes only the lock record of a lock this run has just taken — internal bookkeeping of the location of the test run, never user-owned state.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $EntryPoint,

        [string] $RunDirectory,

        [string] $RepositoryRoot
    )

    $record = [ordered]@{
        pid              = $PID
        processStartedAt = [System.Diagnostics.Process]::GetCurrentProcess().StartTime.ToUniversalTime().ToString('o')
        entryPoint       = $EntryPoint
        startedAt        = [DateTimeOffset]::Now.ToString('o')
        runDirectory     = $RunDirectory
        repositoryRoot   = $RepositoryRoot
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    $temp = "$Path.$PID.tmp"
    [System.IO.File]::WriteAllText($temp, (ConvertTo-Json -InputObject $record), [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::Move($temp, $Path, $true)
}
