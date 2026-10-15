---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md
    kind: comment-page
    body_sha: "917a3c491dd6"
---

# automation/Catzc.Tooling.Core/Invoke-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Write-Message "uv: allowing pre-release/dev package versions...`.

```text
Pre-release resolution is a deliberate, config-driven relaxation of the version lock — surface it so it
is never silent. A message, not a warning: the toolchain runs with WarningPreference=Stop, and this is
expected (opt-in) behaviour, not an anomaly to halt on.
```
