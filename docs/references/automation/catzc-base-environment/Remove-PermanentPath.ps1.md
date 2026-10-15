---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Remove-PermanentPath.ps1.md
    kind: comment-page
    body_sha: "058c1e7e5f38"
---

# automation/Catzc.Base.Environment/Remove-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($IsWindows) {`, written with `#`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```
