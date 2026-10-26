# pwsh/Base.Execution/tests/Find-Executable.Tests.ps1

The tests of `Find-Executable`, hermetic logic at L1.

## Fixtures

The candidate executables are fixture files under `$TestDrive`, reached through a fixture environment variable so the `%VAR%` expansion is
exercised. The session actor, the PATH lookup and the version run (`Get-ExecutableVersion`, the probe's only process start) are mocked.
Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Cold cache

Every test exercises the version cache entry, so each starts cold
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)).
