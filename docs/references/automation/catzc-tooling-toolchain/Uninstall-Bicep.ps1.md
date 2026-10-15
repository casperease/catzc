---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Bicep.ps1.md
    kind: reference
    body_sha: c36acd6846a9
    adrs: []
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Bicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows and macOS delegate to Uninstall-Tool with the tools.yml `bicep` entry (winget, brew). On Linux it removes the
binary Install-Bicep placed in ~/.local/bin; a Bicep CLI elsewhere is not this module's to remove.
```
