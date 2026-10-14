<#
.SYNOPSIS
    Releases a test run's location claimed by Enter-TestRunLocation.
.DESCRIPTION
    In place: for each lock the location holds — the user's system-test lock (Enter-SystemTestLock), then the
    working folder's — deletes the lock record this run wrote (only while it is still ours), then releases and
    disposes the mutex — record first, so the next holder's record is never deleted. Snapshot: removes the
    snapshot (Remove-RepositorySnapshot), unless the location's KeepSandbox keeps it for a post-mortem, in
    which case its path is announced. A worker's lock-free in-place location releases nothing.
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
        # Hand the snapshot's result caches home before it goes: the checks this run made in the snapshot are as
        # valid for the working folder as for the snapshot, since each entry is keyed on a file's content and the
        # check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). Save-ResultCache
        # merges them with what the working folder's cache holds.
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
