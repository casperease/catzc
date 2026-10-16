<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestRunLockRecord.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
  config:
    synopsis: Writes the record that names who holds a test-run lock.
    description: |-
      A lock (the working folder's, Enter-TestRunLocation; the user's system-test lock, Enter-SystemTestLock) says only
      that it is held; the record beside it says by whom, so a run that finds the lock held can name the holder
      (Get-TestRunLockHolder) instead of guessing. The record carries the holder's pid and process start time (a
      reused pid is told apart), the entry point, when it started, its run folder and its working folder. The write
      is atomic — a temp file moved over the record — so a reader never sees half of it.
    parameters:
      Path: The record file. Its folder is created when missing.
      EntryPoint: The entry point holding the lock ('Test-Automation', 'Invoke-TestFile', …).
      RunDirectory: The holder's run folder.
      RepositoryRoot: The holder's working folder — what tells two checkouts apart for a user-wide lock.
    outputs: None.
    examples:
      - Write-TestRunLockRecord -Path $lockPath -EntryPoint 'Test-Automation' -RunDirectory $runDir -RepositoryRoot $root
---
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
