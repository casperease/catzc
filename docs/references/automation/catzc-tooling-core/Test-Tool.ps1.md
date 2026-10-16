---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7b092eb8ff66"
---

# automation/Catzc.Tooling.Core/Test-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {`, written with `#`.

```text
Devbox lever (mirrors Assert-ToolVersion): outside a CI pipeline, also accept an installed version
matching the tool's devbox_version prefix, so a levered off-pin tool reads as usable for quality gates
too — not just runtime asserts.
```
