---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-GoTestCases.Tests.ps1.md
    kind: test-asset
    body_sha: e5a9a50f59a3
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1

<!-- cspell:ignore Testlowercase -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GoTestCases' -Tag 'L0', 'logic' {`.

```text
Get-GoTestCases over a fixture Go test folder in $TestDrive (the go config mocked to its defaults): the Go tests are
read from the *_test.go source, never by running go. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
