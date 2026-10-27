# pwsh/Base.ModuleSystem/types/ArtifactsConfig.cs

The typed record for `artifacts.yml`: the feeds a CI build promotes the versioned, immutable gold module-manifest artifact to (the build
verification test's gold output,
[ADR-AUTO-TEST-BUILDVERIFICATIONTEST](../../../../drs/automation/test-automation.md#rule-adr-auto-test-buildverificationtest)). It is
registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config artifacts` returns it. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one `ArgumentException`:

- exactly the top-level keys `ado`, `github` and `artifactory` are allowed, and each is required;
- each key holds a well-formed publish target (`ArtifactsTarget`: `enabled` plus that target's coordinates).

## Properties

- **`ado`** — the Azure DevOps Artifacts target (`AdoArtifactsTarget`).
- **`github`** — the GitHub Packages target (`GithubArtifactsTarget`).
- **`artifactory`** — the JFrog Artifactory target (`ArtifactoryArtifactsTarget`).

No publish code reads the targets yet, so they are inert configuration surface, but the file still loads validated.
