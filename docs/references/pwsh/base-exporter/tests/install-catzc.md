# pwsh/Base.Exporter/tests/Install-Catzc.Tests.ps1

The L0 tests of `Install-Catzc`, against a fixture build in `TestDrive:`.

## Fixtures

The fixture is a build with neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). Its integrity guard
is a boundary here, since `Assert-CatzcBundle` has its own tests. The fixture's `Import-Catzc.ps1` records how it was invoked, so
dot-sourcing the generated root importer proves the wiring without loading a platform.
