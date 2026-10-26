# pwsh/Base.QualityGates/tests/Measure-QualityGates.Tests.ps1

The L0 logic test of `Measure-QualityGates`, run over fixture quality gates. The real `Get-Command` lookup and the `-OutputFolder` probe
decide each call, and the timing itself is read only for its order. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
