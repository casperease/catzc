---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-PythonWorkspaceTool.Tests.ps1.md
    kind: test-asset
    body_sha: ff275cb8af71
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-PythonWorkspaceTool' -Tag 'L0', 'logic' {`.

```text
Invoke-PythonWorkspaceTool with uv mocked (Resolve-ToolExecutable, Invoke-Executable) over a fixture workspace in
$TestDrive. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
