# pwsh/Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1

The tests of the `EngineSetCheck` type, which maps the engine-set check's settings and matches its phrases against the engine names it is
given. Widget, gadget and sprocket stand in for the model's engines
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)),
so no engine name or count is a literal of the check
([ADR-AUTO-ENGINE-THREEENGINES](../../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)).
