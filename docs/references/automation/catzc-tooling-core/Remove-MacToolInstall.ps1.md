---
catzc:
  immutable:
    with_body_sha: "7c353656a0e1"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-core/Remove-MacToolInstall.ps1.md
    folder: docs/references/automation/catzc-tooling-core
    name: remove-mac-tool-install-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Core/Remove-MacToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (Test-Command brew) {`, written with `#`.

```text
1. Homebrew-owned shadow — a binary under the brew prefix, symlinked into the Cellar. The symlink target
   carries the formula name (.../Cellar/<formula>/<version>/bin/<cmd>); brew uninstall is user-space.
```
