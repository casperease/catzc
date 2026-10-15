---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Wait-Mutex.ps1.md
    kind: comment-page
    body_sha: ae0b78d8fd7b
---

# automation/Catzc.Base.Execution/Wait-Mutex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$waitSeconds = if ($announced) {`.

```text
Wait in observation-sized slices: up to the announce threshold first, then one dot interval
per slice — a failed slice is exactly one console event (the announcement, or a dot).
```
