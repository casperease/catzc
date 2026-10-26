# pwsh/Base.Folders/tests/types/FolderWalkConfig.Tests.ps1

The L0 tests of `FolderWalkConfig`, the typed record of `folder-walk.yml`.

## What they prove

`FolderWalkConfig` maps `folder-walk.yml` and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An
omitted key behaves exactly like the default, since the type is the only place a folder-walk default lives and every walker must find the two
indistinguishable. A malformed value fails at construction with every violation named.
