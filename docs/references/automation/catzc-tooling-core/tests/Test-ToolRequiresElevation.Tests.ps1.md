---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Test-ToolRequiresElevation.Tests.ps1.md
    kind: test-asset
    body_sha: "29b1fe3a00ef"
---

# automation/Catzc.Tooling.Core/tests/Test-ToolRequiresElevation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-TestToolConfig {`.

```text
The production input is the typed record Get-ToolConfig returns, so the tests build one: a flag the record
does not map would be absent here exactly as in production.
```
