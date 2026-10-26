# pwsh/Base.Objects/types/ArtifactRef.cs

An immutable, dual-form descriptor for a published-artifact file. One build stage produces it and writes it into an artifact folder; a later
deploy stage, on a different agent or machine, downloads that folder and consumes it.

## Identity across the boundary

The stable identity is artifact-relative (for example `main.json`), not `out/`-anchored: ADO publishes `out/template/<name>` as artifact
`<name>` and strips the `out/template/` prefix, so the producer's output root does not survive the rename. The anchor that does survive is the
artifact root itself, the producer's `output_folder` and the consumer's `$(Pipeline.Workspace)/<name>`
([ADR-AUTO-PATH-PUBLISHEDARTIFACT](../../../../drs/automation/path-representation.md#rule-adr-auto-path-publishedartifact)).

## Two forms

`relative` is the artifact-internal, forward-slash path, the portable identity. `absolute` is resolved in the producing context and is for
audit and reference only, meaningless at the other end.

## Members

- **`Materialize(rawPath, artifactRoot)`** — the controlled factory: it takes a raw path, absolute or relative to the artifact root, converts
  once and produces both forms. The file must live under the artifact root; anything else is a bug, so it throws rather than degrade. The
  `(relative, absolute)` constructor rehydrates an instance from deserialized manifest JSON.
- **`ResolveAt(artifactRoot)`** — re-resolves to an absolute path under the consumer's artifact root, which is how the other end binds the
  artifact in its own downloaded location.
- **`ExistsAt(artifactRoot)`** — the consumer-side check, run before binding. The check at the other end lives on this type, not in every
  consumer.
