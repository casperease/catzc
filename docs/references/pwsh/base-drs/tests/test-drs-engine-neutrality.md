# pwsh/Base.Drs/tests/Test-DrsEngineNeutrality.Tests.ps1

The tests of `Test-DrsEngineNeutrality`.

## Fixtures

They run over a fixture `docs/drs` tree in `$TestDrive`, a fixture `DrsConfig` and a fixture `DrsChecksConfig`, with `Get-Config` and
`Resolve-RepoPath` mocked. The names and tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
