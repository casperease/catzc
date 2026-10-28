# pwsh/Base.Drs/tests/types/DrsChecksConfig.Tests.ps1

The tests of `DrsChecksConfig`, the settings of the DRS checks (`drs-checks.yml`): every key is optional with its default declared once on
the type, and every violation is collected into one throw.

## Fixtures

The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
