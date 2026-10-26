# pwsh/Base.QualityGates/tests/Invoke-Prettier.Tests.ps1

The L0 logic test of the prettier engine `Invoke-Prettier`, with the tool boundary mocked
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)), because a unit test never
launches a real process. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
