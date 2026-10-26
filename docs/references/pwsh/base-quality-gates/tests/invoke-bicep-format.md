# pwsh/Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1

The L0 logic test of the bicep engine `Invoke-BicepFormat`, with the tool boundary mocked
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)). The probe finds a managed
Bicep CLI, and the mock writes the `--outfile` copy that the engine compares. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## The fake formatter

The mock of `Invoke-Executable` collapses runs of spaces in every file the `--pattern` names, in place, as `bicep format --pattern` does.
