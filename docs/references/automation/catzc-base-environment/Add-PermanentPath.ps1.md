---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Add-PermanentPath.ps1.md
    kind: comment-page
    body_sha: "02765afcf1fa"
---

# automation/Catzc.Base.Environment/Add-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `if ($IsWindows) {`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```
