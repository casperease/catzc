# pwsh/Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1

The L0 logic test of `Get-TestAutomationTestPaths`, run over a fixture `pwsh/` tree in `$TestDrive`, with `Get-RepositoryRoot` and
`Get-ModuleOrder` mocked. The tree holds two modules with tests, one without, and one dot-prefixed infrastructure folder. The fixtures use
neutral names ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
