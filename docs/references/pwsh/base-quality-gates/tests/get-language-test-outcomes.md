# pwsh/Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1

The tests of `Get-LanguageTestOutcomes` with the language runners mocked. Every discovered test takes the outcome of its result, or skips
with `tool_<tool>_missing` when the run's source session handed down no managed tool. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Engines

The engine case runs once for every engine other than the running pwsh, taken from the model
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)).
