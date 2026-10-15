---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/private/Format-FileLockingProcess.ps1.md
    kind: comment-page
    body_sha: "63591df01d0e"
    adrs: []
---

# automation/Catzc.Base.TypesSystem/private/Format-FileLockingProcess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Joins the holders into "pwsh.exe (PID 10276, started 2026-10-13 14:10) — the VS Code PowerShell
extension, this session (PID 37552)". The current process is labelled "this session"; a VS Code
PowerShell Editor Services host is named as such, since its pwsh.exe is otherwise indistinguishable from
a console. Returns $null when there are no holders, so the caller can fall back to holder-free wording.
```
