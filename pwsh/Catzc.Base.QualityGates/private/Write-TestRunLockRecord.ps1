<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Write-TestRunLockRecord.ps1
    folder: private
    name: write-test-run-lock-record
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Write-TestRunLockRecord.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Write-TestRunLockRecord.ps1.md)"
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
