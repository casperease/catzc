# pwsh/Base.Globs/tests/Get-GlobSet.Tests.ps1

The tests of `Get-GlobSet`, the reader of the globset registry.

## Fixtures

The fixture globset names are neutral (widget, gadget), not the real loose-fileset and deployable-unit names, so the logic test owns its
inputs and editing the shipped `globs.yml` can never change its outcome
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
