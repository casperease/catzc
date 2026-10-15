---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-InstallScope.ps1.md
    kind: comment-page
    body_sha: ef645e3d4e71
    adrs: []
---

# automation/Catzc.Tooling.Core/Get-InstallScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Determines whether a tool is installed in user-space or machine-wide
by inspecting the binary path. Returns 'user', 'machine', or 'unknown'.
```
