# pwsh/Base.QualityGates/tests/types/LinksConfig.Tests.ps1

The test of the `LinksConfig` type, which maps `links.yml` and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An
omitted key behaves exactly like the default, and a malformed value fails at construction with the allowed set.
