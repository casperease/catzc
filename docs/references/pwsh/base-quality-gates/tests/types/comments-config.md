# pwsh/Base.QualityGates/tests/types/CommentsConfig.Tests.ps1

The tests of the `CommentsConfig` type, which maps `comments.yml` and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An
omitted key behaves exactly like the default, and a malformed value fails at construction and names the key.
