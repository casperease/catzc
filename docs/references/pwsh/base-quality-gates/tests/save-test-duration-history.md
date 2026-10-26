# pwsh/Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1

The L0 logic test of the per-machine test duration history: `Save-TestDurationHistory` merges a run's measurements, and
`Get-TestDurationHistory` reads them back. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
