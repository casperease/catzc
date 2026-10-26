# pwsh/Base.Reports/tests/Write-QualityGateReport.Tests.ps1

The tests of `Write-QualityGateReport`, every quality gate's output: each test pins one part of the uniform shape
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## The setup

The settings come from the real `ReportsConfig` type over a mocked reports config, and the report goes to `$TestDrive`, so the shape every
gate's report shares is pinned without writing outside the test drive. The fixture subjects are neutral (widget and gadget,
[ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
