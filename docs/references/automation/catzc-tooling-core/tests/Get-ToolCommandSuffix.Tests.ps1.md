---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Get-ToolCommandSuffix.Tests.ps1.md
    kind: comment-page
    body_sha: be844779fd35
---

# automation/Catzc.Tooling.Core/tests/Get-ToolCommandSuffix.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `It 'maps snake_case key <Tool> to PascalCase suffix <Expected>' -ForEach @(`, written with `#`.

```text
Each snake_case tools.yml key must map to the PascalCase suffix of its
Install-/Uninstall-/Invoke- commands. (Existence of those commands per
tool is covered in Get-ToolConfig.Tests.)
```
