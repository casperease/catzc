---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Exit-TestRunLocation.ps1.md
    kind: comment-page
    body_sha: f0a9c7a82957
    adrs:
      - ADR-AUTO-CACHE#10
    links: []
---

# automation/Catzc.Base.QualityGates/private/Exit-TestRunLocation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
In place: for each lock the location holds — the user's system-test lock (Enter-SystemTestLock), then the
working folder's — deletes the lock record this run wrote (only while it is still ours), then releases and
disposes the mutex — record first, so the next holder's record is never deleted. Snapshot: removes the
snapshot (Remove-RepositorySnapshot), unless the location's KeepSandbox keeps it for a post-mortem, in
which case its path is announced. A worker's lock-free in-place location releases nothing.
```

## comment:2

Above `$snapshotCache = Join-Path $Location.Snapshot.Path 'out/cache'`.

```text
Hand the snapshot's result caches home before it goes: the checks this run made in the snapshot are as
valid for the working folder as for the snapshot, since each entry is keyed on a file's content and the
check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). Save-ResultCache
merges them with what the working folder's cache holds.
```
