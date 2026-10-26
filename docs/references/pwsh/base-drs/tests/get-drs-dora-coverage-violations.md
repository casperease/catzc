# pwsh/Base.Drs/tests/Get-DrsDoraCoverageViolations.Tests.ps1

The tests of `Get-DrsDoraCoverageViolations`: every rule set outside the domains the config exempts has exactly one section linking its ADR
in its domain's DORA file.

## Fixtures

A fixture tree in `$TestDrive` and a fixture registry, with neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
