---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Test-FileIsLocked.ps1.md
    kind: comment-page
    body_sha: "49fdc4774f0c"
    adrs: []
    links: []
---

# automation/Catzc.Base.Files/Test-FileIsLocked.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Tries to open the file for reading with no sharing. If another handle is open (e.g. a loaded assembly
DLL), the open fails with an IOException and the file is reported locked; if the open succeeds it is
closed immediately and the file is reported not locked.

File locking is mandatory on Windows but advisory on Linux/macOS, where a file held open elsewhere may
still open — so this reports $false there. Callers that must not stall on a locked file (e.g. cache
cleanup) should still prefer a guarded delete; this predicate is for asserting and reporting state.
```
