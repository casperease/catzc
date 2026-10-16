---
catzc:
  immutable:
    with_body_sha: "774a05038bf6"
    path: docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md
    folder: docs/references/automation/catzc-tooling-core/private
    name: remove-uv-pip-or-stray-install-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
