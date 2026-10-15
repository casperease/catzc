---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md
    kind: test-asset
    body_sha: d8d102090ad8
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-TestAutomationTestPaths' -Tag 'L0', 'logic' {`.

```text
Get-TestAutomationTestPaths over a fixture automation tree in $TestDrive (Get-RepositoryRoot and
Get-ModuleTestOrder mocked): two modules with tests, one without, and one dot-prefixed infrastructure folder.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
