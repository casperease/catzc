# pwsh/Base.Docs/tests/types/GlossaryConfig.Tests.ps1

The tests of the compiled `GlossaryConfig` type and the records it builds (`GlossaryOptions`, `GlossaryConcept`, `GlossaryRealization`,
`GlossaryAvoid`), called directly: the constructor is the guard that stops a malformed glossary source from ever producing an instance. Only
the self-contained load-time rules live here; the cross-source and cross-file checks belong to the glossary checks. Fixture terms are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
Each test copies a well-formed concept body and breaks one thing.
