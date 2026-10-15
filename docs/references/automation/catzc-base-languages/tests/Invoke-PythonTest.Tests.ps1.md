---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md
    kind: test-asset
    body_sha: "9fa3ddbb0384"
    adrs:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`.

```text
Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
fixture repository root in $TestDrive, a mocked tool probe (Resolve-ToolExecutable) that finds a managed uv
at a fixture path with a space in it, and a mocked uv (Invoke-Executable) whose pytest writes a canned JUnit
report from tests/assets to the path the command names.
```
