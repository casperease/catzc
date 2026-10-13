<#
.SYNOPSIS
    Releases a test-run slot claimed by Enter-TestRunSlot.
.DESCRIPTION
    In place: for each lock the slot holds — the user's system-test lock (Enter-SystemTestLock), then the
    working folder's — deletes the lock record this run wrote (only while it is still ours), then releases and
    disposes the mutex — record first, so the next holder's record is never deleted. Snapshot: removes the
    snapshot (Remove-RepositorySnapshot), unless -KeepSandbox asks to keep it for a post-mortem, in which case
    its path is announced. A worker's lock-free in-place slot releases nothing.
.PARAMETER Slot
    The slot Enter-TestRunSlot returned.
.PARAMETER KeepSandbox
    Keep a snapshot after the run instead of deleting it.
.OUTPUTS
    None.
#>
function Exit-TestRunSlot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Slot,

        [switch] $KeepSandbox
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

    if ($Slot.SystemTestLock) {
        & $release $Slot.SystemTestLock.Mutex $Slot.SystemTestLock.LockPath
    }
    if ($Slot.Mutex) {
        & $release $Slot.Mutex $Slot.LockPath
    }

    if ($Slot.Snapshot) {
        if ($KeepSandbox) {
            Write-Message "Kept the snapshot for inspection (-KeepSandbox): $($Slot.Snapshot.Path)"
        }
        else {
            Remove-RepositorySnapshot $Slot.Snapshot.Path
        }
    }
}
