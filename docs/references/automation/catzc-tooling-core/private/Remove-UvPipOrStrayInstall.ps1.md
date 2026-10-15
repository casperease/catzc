---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md
    kind: comment-page
    body_sha: "70b9bfd8f38a"
---

# automation/Catzc.Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `if ([System.IO.File]::Exists($Source)) {`.

```text
Stray binary no manager owns — delete just the resolved file (a root-owned path fails the delete loudly
rather than being force-removed silently).
```
