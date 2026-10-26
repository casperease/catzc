# pwsh/Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1

The tests of `FileMetaConfig`, which maps `file-meta.yml` and is the one declaration of its defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): an
omitted key behaves exactly like the default, and a malformed value fails at construction with the allowed set.
