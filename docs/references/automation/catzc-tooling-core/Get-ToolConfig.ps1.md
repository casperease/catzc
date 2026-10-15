---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-ToolConfig.ps1.md
    kind: comment-page
    body_sha: eb25f2d68098
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Core/Get-ToolConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Looks one tool's locked definition up in configs/tools.yml, read through Get-Config — which constructs the
typed Catzc.Base.Execution.ToolsConfig once per session (validating every entry) and caches it, so repeated
calls return the same ToolConfig instance.
```
