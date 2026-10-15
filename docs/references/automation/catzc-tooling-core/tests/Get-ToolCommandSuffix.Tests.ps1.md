---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Get-ToolCommandSuffix.Tests.ps1.md
    kind: test-asset
    body_sha: "4da49e9d56e6"
---

# automation/Catzc.Tooling.Core/tests/Get-ToolCommandSuffix.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `It 'maps snake_case key <Tool> to PascalCase suffix <Expected>' -ForEach @(`.

```text
Each snake_case tools.yml key must map to the PascalCase suffix of its
Install-/Uninstall-/Invoke- commands. (Existence of those commands per
tool is covered in Get-ToolConfig.Tests.)
```
