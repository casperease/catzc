# pwsh/Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1

The L0 logic test of `Test-ShippedConfigs`, over a fixture code root in `$TestDrive`, with the registry and `Get-Config` mocked in the
gate's scope. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
