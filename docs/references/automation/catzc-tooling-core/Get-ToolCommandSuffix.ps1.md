---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-ToolCommandSuffix.ps1.md
    kind: comment-page
    body_sha: "0e4221406ec7"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Core/Get-ToolCommandSuffix.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Tool identities in tools.yml are snake_case (e.g. 'az_cli', 'node_js', 'py_spark'),
matching the config-naming ADR. The per-tool commands, however, follow the module's
Verb-Noun convention (Install-AzCli, Remove-NodeJs, Uninstall-PySpark). This converts
the config key to that command suffix so name-based dispatch and user-facing
"Run Install-<x>" messages resolve correctly: 'az_cli' -> 'AzCli'.
```
