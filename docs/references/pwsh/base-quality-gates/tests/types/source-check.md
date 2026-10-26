# pwsh/Base.QualityGates/tests/types/SourceCheck.Tests.ps1

The test of the `SourceCheck` type. It maps the settings that every source check shares, its mode and exempt globs, and is the one
declaration of their sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An
exempt file is a declared entry with its reason
([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../../drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)).
