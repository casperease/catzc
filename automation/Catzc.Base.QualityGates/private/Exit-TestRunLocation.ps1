<#
.SYNOPSIS
    Releases a test run's location claimed by Enter-TestRunLocation.
.DESCRIPTION
    The record goes before the mutex so the next holder's record survives; a lock-free worker location frees nothing.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Exit-TestRunLocation.ps1.md#comment1)
.PARAMETER Location
    The location Enter-TestRunLocation returned.
.OUTPUTS
    None.
#>
function Exit-TestRunLocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Location
    )

    # Record first (only while it is still ours), then the mutex, so the next holder's record is never deleted.
    $release = {
        param([System.Threading.Mutex] $Mutex, [string] $LockPath)
        try {
            if ($LockPath -and [System.IO.File]::Exists($LockPath)) {
                $record = try {
                    [System.IO.File]::ReadAllText($LockPath) | ConvertFrom-Json
                }
                catch {
                    $null
                }
                if ($record -and $record.PSObject.Properties['pid'] -and [int] $record.pid -eq $PID) {
                    [System.IO.File]::Delete($LockPath)
                }
            }
        }
        finally {
            $Mutex.ReleaseMutex()
            $Mutex.Dispose()
        }
    }

    if ($Location.SystemTestLock) {
        & $release $Location.SystemTestLock.Mutex $Location.SystemTestLock.LockPath
    }
    if ($Location.Mutex) {
        & $release $Location.Mutex $Location.LockPath
    }

    if ($Location.Snapshot) {
        # Content-keyed entries stay valid in the working folder, so the snapshot's checks are not lost with it.
        # [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Exit-TestRunLocation.ps1.md#comment2)
        $snapshotCache = Join-Path $Location.Snapshot.Path 'out/cache'
        if ([System.IO.Directory]::Exists($snapshotCache)) {
            foreach ($file in [System.IO.Directory]::GetFiles($snapshotCache, '*.json')) {
                Save-ResultCache -Path (Join-Path (Get-OutputRoot) "cache/$([System.IO.Path]::GetFileName($file))") -Cache (Get-ResultCache -Path $file)
            }
        }
        if ($Location.KeepSandbox) {
            Write-Message "Kept the snapshot for inspection (-KeepSandbox): $($Location.Snapshot.Path)"
        }
        else {
            Remove-RepositorySnapshot $Location.Snapshot.Path
        }
    }
}
