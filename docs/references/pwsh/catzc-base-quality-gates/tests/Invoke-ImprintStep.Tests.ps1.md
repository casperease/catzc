# pwsh/Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1

The L0 logic test of `Invoke-ImprintStep`, run over fixture files in `$TestDrive`. Its seams are mocked: the registries through `Get-Config`,
and the C# namespace command `Format-Types`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The fixture kind

A fixture kind with a fixture processor lets the test prove the step on a fact of its own, whatever kinds the shipped registry holds.
