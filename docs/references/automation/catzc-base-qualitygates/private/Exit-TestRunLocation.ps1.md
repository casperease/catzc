---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Exit-TestRunLocation.ps1.md
    kind: comment-page
    body_sha: "9a87039c96b7"
    adrs:
      - ADR-AUTO-CACHE#10
---

# automation/Catzc.Base.QualityGates/private/Exit-TestRunLocation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$snapshotCache = Join-Path $Location.Snapshot.Path 'out/cache'`.

```text
Hand the snapshot's result caches home before it goes: the checks this run made in the snapshot are as
valid for the working folder as for the snapshot, since each entry is keyed on a file's content and the
check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). Save-ResultCache
merges them with what the working folder's cache holds.
```
