---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Uv.ps1.md
    kind: comment-page
    body_sha: "0c45f574db82"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes the managed install via the platform package manager: winget (Windows) or brew (macOS).
Delegates to Uninstall-Tool. Idempotent — skips if not installed.
```
