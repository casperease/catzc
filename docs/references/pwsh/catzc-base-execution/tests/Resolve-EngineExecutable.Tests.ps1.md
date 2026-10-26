# pwsh/Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1

The tests of `Resolve-EngineExecutable`.

## Fixtures

The tool probe is mocked for the tool-located engines, with neutral fixture paths
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
`pwsh` is located beside the running PowerShell for real, which needs nothing but the session itself.
