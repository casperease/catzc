# pwsh/Catzc.Base.QualityGates/private/Exit-TestRunLocation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$snapshotCache = Join-Path $Location.Snapshot.Path 'out/cache'`, written with `#`.

```text
Hand the snapshot's result caches home before it goes: the checks this run made in the snapshot are as
valid for the working folder as for the snapshot, since each entry is keyed on a file's content and the
check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). Save-ResultCache
merges them with what the working folder's cache holds.
```
