# docs/references/automation/catzc-base-modulesystem/types/ArtifactsTarget.cs.md

`automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One publish target of configs/artifacts.yml (`ado:`, `github:`, `artifactory:`) — a feed a CI build promotes the
gold module-manifest artifact to. The shared shape every target has: an `enabled` switch plus the target's own
string coordinates (AdoArtifactsTarget, GithubArtifactsTarget, ArtifactoryArtifactsTarget declare them).
Constructing one VALIDATES the entry, collecting every violation into one throw:
  - the entry is a mapping carrying exactly 'enabled' and the target's coordinate keys (none missing, none extra);
  - 'enabled' is a boolean;
  - each coordinate is a string — it may be empty ('') while the target is disabled, and must be non-empty once
    it is enabled (an enabled target needs somewhere to publish).
Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
