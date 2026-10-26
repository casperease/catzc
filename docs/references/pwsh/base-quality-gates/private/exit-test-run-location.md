# pwsh/Base.QualityGates/private/Exit-TestRunLocation.ps1

Releases a test run's location: the system-test lock and the working-folder lock, then the snapshot when there is one. A lock's record is
deleted only while it is still the releasing process's own, so the next holder's record is never removed.

## help

### synopsis

Releases a test run's location claimed by Enter-TestRunLocation.

### description

In place: for each lock the location holds — the user's system-test lock (Enter-SystemTestLock), then the working folder's — deletes the
lock record this run wrote (only while it is still ours), then releases and disposes the mutex — record first, so the next holder's record
is never deleted. Snapshot: removes the snapshot (Remove-RepositorySnapshot), unless the location's KeepSandbox keeps it for a post-mortem,
in which case its path is announced. A worker's lock-free in-place location releases nothing.

### parameter `Location`

The location Enter-TestRunLocation returned.

### outputs

None.

## handing the caches home

The snapshot's result caches go home before the snapshot is removed. The checks the run made in the snapshot are as valid for the working
folder as for the snapshot, since each entry is keyed on a file's content and the check's inputs
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)).
Save-ResultCache merges them with what the working folder's cache holds.
