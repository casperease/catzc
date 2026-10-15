---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-BashTestCases.Tests.ps1.md
    kind: test-asset
    body_sha: "84513c65e113"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-BashTestCases' -Tag 'L0', 'logic' {`.

```text
Get-BashTestCases over fixture .bats files in $TestDrive: the @test declarations of every .bats file, with the file
path bats reports as their package. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
