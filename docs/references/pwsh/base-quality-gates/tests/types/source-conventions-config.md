# pwsh/Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1

The test of the `SourceConventionsConfig` type, which maps `source-conventions.yml`. An omitted check takes every default of its type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and an
unknown key fails at construction.
