---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md
    kind: test-asset
    body_sha: "6d626f9b1d9f"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ManualTestPlan' -Tag 'L0', 'logic' {`.

```text
Test-ManualTestPlan over a fixture repository in $TestDrive: the repository root is mocked, and each test writes the
test files and the plan rows it needs. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
