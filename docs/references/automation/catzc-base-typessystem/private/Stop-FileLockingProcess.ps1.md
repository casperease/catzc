---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/private/Stop-FileLockingProcess.ps1.md
    kind: comment-page
    body_sha: f4893c209ae2
---

# automation/Catzc.Base.TypesSystem/private/Stop-FileLockingProcess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Asks Get-FileLockingProcess who holds the file and stops each holder, waiting briefly for it to exit so its
handle is released. Every stop is announced, naming the process and the file, because stopping a process can
lose its unsaved work. Never stopped: this session ($PID) and every ancestor of it — the terminal, the editor
host, or the shell that launched this session; stopping one of those would end the very session asking. Such a
holder is reported instead, for the caller's error to name. A process that cannot be stopped (another user's,
or an elevated one) is reported and left. On a host without mandatory file locking there are no holders, and
this does nothing.
```
