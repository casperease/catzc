---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Invoke-Uv.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b65c83c60830
---

# automation/Catzc.Tooling.Core/Invoke-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Write-Message "uv: allowing pre-release/dev package versions...`, written with `#`.

```text
Pre-release resolution is a deliberate, config-driven relaxation of the version lock — surface it so it
is never silent. A message, not a warning: the toolchain runs with WarningPreference=Stop, and this is
expected (opt-in) behaviour, not an anomaly to halt on.
```
