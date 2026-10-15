---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Postman.ps1.md
    kind: reference
    body_sha: "4cb4bc43d12f"
    adrs: []
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Postman.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: Removes LOCALAPPDATA\Postman directory.
macOS: brew uninstall --cask postman.
Linux: Removes HOME/.local/Postman directory.
Idempotent — skips if not installed.
```
