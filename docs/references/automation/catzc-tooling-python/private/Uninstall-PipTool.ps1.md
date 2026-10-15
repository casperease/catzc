---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-python/private/Uninstall-PipTool.ps1.md
    kind: comment-page
    body_sha: bd42c877b8d4
---

# automation/Catzc.Tooling.Python/private/Uninstall-PipTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Private helper for Uninstall-PySpark. Mirrors Uninstall-Tool's contract but removes the package from the
uv-managed Python with `uv pip uninstall --system`. Idempotent — skips if the tool or Python is not
installed.
```
