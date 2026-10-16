<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Exit-TestRunLocation.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Exit-TestRunLocation.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Exit-TestRunLocation.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: Releases a test run's location claimed by Enter-TestRunLocation.
    description: |-
      In place: for each lock the location holds — the user's system-test lock (Enter-SystemTestLock), then the
      working folder's — deletes the lock record this run wrote (only while it is still ours), then releases and
      disposes the mutex — record first, so the next holder's record is never deleted. Snapshot: removes the
      snapshot (Remove-RepositorySnapshot), unless the location's KeepSandbox keeps it for a post-mortem, in
      which case its path is announced. A worker's lock-free in-place location releases nothing.
    parameters:
      Location: The location Enter-TestRunLocation returned.
    outputs: None.
---
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
