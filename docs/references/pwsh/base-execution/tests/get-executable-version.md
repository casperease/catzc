# pwsh/Base.Execution/tests/Get-ExecutableVersion.Tests.ps1

The tests of `Get-ExecutableVersion`, the probe's only process start, with `Invoke-Executable` mocked.

## What they pin

The located path is run, quoted, never a bare name, and the version is the pattern's named group. Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
