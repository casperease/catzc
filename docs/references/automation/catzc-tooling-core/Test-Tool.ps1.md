---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Test-Tool.ps1.md
    kind: comment-page
    body_sha: dde677df719d
---

# automation/Catzc.Tooling.Core/Test-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `if ($config.devbox_version -and -not (Test-IsRunningInPipeline)) {`.

```text
Devbox lever (mirrors Assert-ToolVersion): outside a CI pipeline, also accept an installed version
matching the tool's devbox_version prefix, so a levered off-pin tool reads as usable for quality gates
too — not just runtime asserts.
```
