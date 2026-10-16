---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Exit-TestRunLocation.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "873d0a9f0bde"
    adrs:
      - ADR-AUTO-CACHE#10
---

# automation/Catzc.Base.QualityGates/private/Exit-TestRunLocation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$snapshotCache = Join-Path $Location.Snapshot.Path 'out/cache'`, written with `#`.

```text
Hand the snapshot's result caches home before it goes: the checks this run made in the snapshot are as
valid for the working folder as for the snapshot, since each entry is keyed on a file's content and the
check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). Save-ResultCache
merges them with what the working folder's cache holds.
```
