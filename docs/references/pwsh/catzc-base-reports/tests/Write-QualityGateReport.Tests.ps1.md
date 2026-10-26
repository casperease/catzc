# pwsh/Base.Reports/tests/Write-QualityGateReport.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Write-QualityGateReport'`, written with `#`.

```text
Write-QualityGateReport is every quality gate's output. The settings come from the real ReportsConfig type over a
mocked reports config, and the report goes to $TestDrive, so each test pins one part of the uniform shape
([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Neutral fixture subjects
(widget/gadget, [ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Write-QualityGateReport'`, written with `#`.

```text
The real settings type over a mocked file, so the shape every gate's report shares is pinned without writing outside
the test drive.
```
