# pwsh/Base.Globs/types/GlobsConfig.cs

The typed record for the globset registry (`configs/globs/`) and its validity rules. See
[FDR-GLOBS](../../../../drs/flow/durable-sha-globs.md).

## Shape

The registry is a non-empty `globsets` map of kebab-case name to
`{ description, layer, [include], [exclude], [compose], [verify: { modules, level }], [pipeline] }`. The layer is `deployable-unit` or
`loose-fileset`; `module` is derived-only and rejected here
([FDR-GLOBS-EVERYSETHASLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-everysethaslayer)). Each entry is a valid `GlobSet`,
no unknown keys are allowed anywhere (the strict-config discipline), and compose references resolve to declared sets acyclically
([FDR-GLOBS-COMPOSESETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-composesets)). The config itself is an ordinary tracked
file and may be a member of a set.

Constructing an instance validates the whole registry, collecting all errors, and exposes the sets in registry order.

## Reserved names

`ReservedNames` holds the names reserved for the derived globsets ([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)): the
infra scopes every module's tests depend on. Module folders derive their own sets by convention (`Get-ModuleGlobSet`). A declared set may
not shadow a reserved name, because the declared registry and the derived sets share one name space.

## Compose resolution

Every compose reference names a declared set, never the set itself, and the reference graph is acyclic; effective membership is the union
through the references ([FDR-GLOBS-COMPOSESETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-composesets)).

- A broken compose graph makes `Matches` unsafe, since a cycle would recurse forever, so construction fails at once with everything
  collected so far. That is the final validation step.
- `FindComposeCycle` is a depth-first walk of the compose references that returns the cycle path when one exists, else null. It walks the
  name map only, so it is guarded against unresolved references, which are already reported.

## Track sets

A whole track's set declares its track in `globs.yml` and takes its patterns from the generated `track-sets.yml` part
([FDR-GLOBS-TRACKSETDERIVED](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-tracksetderived)). A part that adds patterns to no
declared set is a stale generated entry and is rejected.
