---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-python/Uninstall-Poetry.ps1.md
    kind: comment-page
    body_sha: "2a2a6ea5a7f9"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Python/Uninstall-Poetry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes the uv-managed install (`uv tool uninstall poetry`) via Uninstall-UvTool. Idempotent — skips if
Poetry is not installed.
```
