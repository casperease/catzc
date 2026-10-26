# pwsh/Base.QualityGates/tests/Get-TestRunContext.Tests.ps1

The L0 logic test of `Get-TestRunContext`, run over fixture locations. The session actor and the tool lookup are mocked, so no real process
or `PATH` state decides the outcome
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
