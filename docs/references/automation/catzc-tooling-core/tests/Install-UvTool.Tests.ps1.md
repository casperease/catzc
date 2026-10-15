---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Install-UvTool.Tests.ps1.md
    kind: test-asset
    body_sha: ac49b72ebe0b
---

# automation/Catzc.Tooling.Core/tests/Install-UvTool.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-TestToolConfig {`.

```text
Get-ToolConfig returns the typed record, so the mocks do too: an optional key the entry omits reads as its
default, exactly as in production.
```
