---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-python/Remove-Python.ps1.md
    kind: reference
    body_sha: "6a906d11f3b1"
    adrs: []
---

# automation/Catzc.Tooling.Python/Remove-Python.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Deletes the Python installation folder and removes it (and its Scripts
subdirectory) from the system-level PATH. Requires Administrator.
Auto-detects the install directory from Get-Command if not specified.

This is for Python installations that do not appear in Apps & Features
or winget. If Python is managed by winget, use Uninstall-Python instead.
```
