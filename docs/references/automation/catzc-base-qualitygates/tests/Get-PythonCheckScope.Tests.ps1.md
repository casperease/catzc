---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md
    kind: test-asset
    body_sha: "31fd2d968630"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-PythonCheckScope' -Tag 'L0', 'logic' {`.

```text
Get-PythonCheckScope with the test folders and the git index mocked: the Python checks read the test folders and every
tracked .py file outside the Python root. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
