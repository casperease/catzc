<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestRunLockRecord.ps1.md"
  header: "generated"
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
