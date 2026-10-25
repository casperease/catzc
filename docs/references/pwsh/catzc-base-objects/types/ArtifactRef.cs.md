# pwsh/Catzc.Base.Objects/types/ArtifactRef.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
An immutable, dual-form descriptor for a published-artifact file — one build stage produces it and writes
it into an artifact folder; a later deploy stage (a different agent/machine) downloads that folder and
consumes it. The stable identity across the boundary is ARTIFACT-RELATIVE (e.g. 'main.json'), NOT
out/-anchored: ADO publishes out/template/<name> as artifact '<name>' and strips the out/template/ prefix,
so the producer's output root does not survive the rename. The anchor that DOES survive is the artifact
root itself (the producer's output_folder, the consumer's $(Pipeline.Workspace)/<name>). See
[ADR-AUTO-PATH-PUBLISHEDARTIFACT](/docs/drs/automation/path-representation.md#rule-adr-auto-path-publishedartifact) and out/plan-consolidated-remnants.md (the
serialized-artifact plan).

`relative` is the artifact-internal, forward-slash path (portable identity); `absolute` is resolved in the
producing context (audit/reference only — meaningless at the other end). The consumer re-resolves
`relative` against ITS OWN artifact root (ResolveAt) and verifies existence (ExistsAt) before binding —
the "check at the other end" lives on this type, not in every consumer.

Materialize(rawPath, artifactRoot) is the controlled factory (converts once, produces both forms); the
(relative, absolute) constructor rehydrates an instance from deserialized manifest JSON.
```

## comment:2

Above `public static ArtifactRef Materialize(string rawPath, string artifactRoot)`, written with `//`.

```text
The controlled factory: take a raw path (absolute, or relative to the artifact root) and the artifact
root, and materialize both forms. The file must live under the artifact root — anything else is a bug,
so it throws rather than degrade.
```

## comment:3

Above `public string ResolveAt(string artifactRoot)`, written with `//`.

```text
Re-resolve to an absolute path under the GIVEN (consumer's) artifact root. This is how the other end
binds the artifact in its own downloaded location.
```
