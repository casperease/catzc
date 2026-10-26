# pwsh/Base.ModuleSystem/types/ArtifactsTarget.cs

The abstract base of one publish target of `artifacts.yml` (`ado:`, `github:`, `artifactory:`): a feed a CI build promotes the gold
module-manifest artifact to. It holds the shape every target shares, an `enabled` switch plus the target's own string coordinates, which
[AdoArtifactsTarget](AdoArtifactsTarget.cs.md), [GithubArtifactsTarget](GithubArtifactsTarget.cs.md) and
[ArtifactoryArtifactsTarget](ArtifactoryArtifactsTarget.cs.md) declare. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing a target validates the entry and gathers every violation into one `ArgumentException`:

- the entry is a mapping carrying exactly `enabled` and the target's coordinate keys, none missing and none extra;
- `enabled` is a boolean;
- each coordinate is a string. It may be empty while the target is disabled, and must be non-empty once the target is enabled, because an
  enabled target needs somewhere to publish.

## Properties

- **`enabled`** — whether the build publishes to this target.
