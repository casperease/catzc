---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Git.ps1.md
    kind: comment-page
    body_sha: a6c28bb36cd9
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Git.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: Removes LOCALAPPDATA\Git and cleans PATH.
macOS: brew uninstall git.
Linux: apt-get remove git (requires root).
Idempotent — skips if not installed.
```
