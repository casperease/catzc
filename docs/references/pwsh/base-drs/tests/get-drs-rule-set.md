# pwsh/Base.Drs/tests/Get-DrsRuleSet.Tests.ps1

The tests of `Get-DrsRuleSet`, in two parts: the command over a fixture `DrsConfig`, and an integrity check of the real registry.

## Unit tests

The command runs over a fixture `DrsConfig` with `Get-Config` mocked. The flattening and the effective codes are `DrsConfig` construction
rules, covered by its type test, so these tests pin only the projection and the `-Domain` filter. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Integrity

`drs.yml` and the ADR rule files must agree, which the quality gate `Test-DrsRegistry` checks
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
