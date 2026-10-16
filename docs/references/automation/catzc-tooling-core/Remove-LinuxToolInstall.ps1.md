---
catzc:
  immutable:
    with_body_sha: dff933650ecc
    path: docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md
    folder: docs/references/automation/catzc-tooling-core
    name: remove-linux-tool-install-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Core/Remove-LinuxToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (Test-Command dpkg) {`, written with `#`.

```text
1. apt-owned shadow — dpkg -S names the package that owns the resolved binary, robust across the config's
   own manager (an apt 'azure-cli' owns /usr/bin/az even though az_cli is a uv tool). apt needs root.
```
