---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Remove-PermanentPath.ps1.md
    kind: comment-page
    body_sha: f97e3e233dab
---

# automation/Catzc.Base.Environment/Remove-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `if ($IsWindows) {`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```
