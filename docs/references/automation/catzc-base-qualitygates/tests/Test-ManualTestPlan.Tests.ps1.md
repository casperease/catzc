---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md
    kind: comment-page
    body_sha: ad307d553bd1
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ManualTestPlan' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-ManualTestPlan over a fixture repository in $TestDrive: the repository root is mocked, and each test writes the
test files and the plan rows it needs. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
