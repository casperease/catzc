---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Uninstall-UvTool.ps1.md
    kind: comment-page
    body_sha: "89e1131e4943"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Core/Uninstall-UvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes a CLI installed via Install-UvTool (`uv tool uninstall <uv_tool>`). Idempotent — skips if the
tool is not installed.
```
