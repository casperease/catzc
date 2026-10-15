---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Remove-MacToolInstall.ps1.md
    kind: comment-page
    body_sha: db6418b76a87
---

# automation/Catzc.Tooling.Core/Remove-MacToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if (Test-Command brew) {`.

```text
1. Homebrew-owned shadow — a binary under the brew prefix, symlinked into the Cellar. The symlink target
   carries the formula name (.../Cellar/<formula>/<version>/bin/<cmd>); brew uninstall is user-space.
```
