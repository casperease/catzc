---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-PythonTestCases.Tests.ps1.md
    kind: test-asset
    body_sha: db2a1deaf4d8
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-PythonTestCases' -Tag 'L0', 'logic' {`.

```text
Get-PythonTestCases over fixture test files in $TestDrive: the top-level test functions of every test_*.py file,
with the package pytest reports for them. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
