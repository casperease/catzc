---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md
    kind: comment-page
    body_sha: "7055eddfb396"
---

# automation/Catzc.Tooling.Core/Remove-LinuxToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if (Test-Command dpkg) {`.

```text
1. apt-owned shadow — dpkg -S names the package that owns the resolved binary, robust across the config's
   own manager (an apt 'azure-cli' owns /usr/bin/az even though az_cli is a uv tool). apt needs root.
```
