# pwsh/Base.Drs/tests/Test-DrsRegistry.Tests.ps1

The tests of `Test-DrsRegistry`, each pinning one rule.

## Fixtures

They run over a fixture `docs/drs` tree in `$TestDrive`, a fixture `DrsConfig` and a fixture `DrsChecksConfig`, with `Get-Config` and
`Resolve-RepoPath` mocked. The names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Dangling codes

The registry cases cite codes the fixture map does not hold, so `Get-DrsDanglingCodeViolations` is mocked for them. The dangling-code cases
run the helper itself.
