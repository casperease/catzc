---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Assert-DevBoxToolsStatus.ps1.md
    kind: comment-page
    body_sha: eada4841d0e3
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Calls Get-ToolsStatus and throws if any tool is Missing or WrongVersion.
Tools with status OK or Usable pass — the tool works regardless of how
it was installed. Chocolatey status is ignored.
```
