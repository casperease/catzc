---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-PythonTestCases.Tests.ps1.md
    kind: comment-page
    body_sha: c2907f8ee136
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-PythonTestCases' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-PythonTestCases over fixture test files in $TestDrive: the top-level test functions of every test_*.py file,
with the package pytest reports for them. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
