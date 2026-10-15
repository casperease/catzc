---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Get-FileLockingProcess.ps1.md
    kind: comment-page
    body_sha: "1039fe8b0f63"
    adrs: []
---

# automation/Catzc.Base.Files/Get-FileLockingProcess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Asks the Windows Restart Manager which processes hold the file — the same API behind Explorer's "file in
use by …" dialog. It needs no admin rights and sees both an open handle and a loaded (mapped) DLL, so it
names the session holding a stale assembly. Each holder is enriched with its executable name, command
line and parent process (one CIM query for all holders); a process that exits between the two lookups
keeps only the Restart Manager's facts (id, app name, start time).

File locking is mandatory on Windows but advisory on Linux/macOS, where an open file blocks neither a
delete nor a rename — so there is no holder to report and this returns nothing there (matching
Test-FileIsLocked, which reports $false).
```
