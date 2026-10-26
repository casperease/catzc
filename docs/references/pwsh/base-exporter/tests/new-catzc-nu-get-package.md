# pwsh/Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1

The L0 tests of `New-CatzcNuGetPackage`, against a minimal fixture build in `TestDrive:`.

## One pack

The fixture build uses neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)) and is packed once:
every assertion is a facet of the one pack
([ADR-AUTO-TEST-ONEIMPORTPERCASE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneimportpercase)), because
`Compress-PSResource` costs real time.
