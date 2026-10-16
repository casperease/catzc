---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "774a05038bf6"
---

# automation/Catzc.Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ([System.IO.File]::Exists($Source)) {`, written with `#`.

```text
Stray binary no manager owns — delete just the resolved file (a root-owned path fails the delete loudly
rather than being force-removed silently).
```
