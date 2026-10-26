# pwsh/Base.Globs/types/GlobSet.cs

One named globset: an area-of-control's mapping onto files under version control. It holds a kebab-case name, a description, a layer, the
authored include and exclude patterns, and the optional composition. See [FDR-GLOBS](../../../../drs/flow/durable-sha-globs.md).

## Shape

The constructor guards the shape: a kebab-case name, a required description, a layer set, an include or compose present, and no duplicate
patterns. The layer is `deployable-unit` or `loose-fileset`
([FDR-GLOBS-EVERYSETHASLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-everysethaslayer)); the derived module layer never
appears in the registry. `Verify` (the test blast-radius scope) and `Pipeline` (the trigger-role binding) are declarative meta annotations.
A globset never composes itself and the compose graph is acyclic
([FDR-GLOBS-COMPOSESETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-composesets)), which `GlobsConfig` asserts across the
whole registry at construction.

## Layers

`DeclaredLayers` holds the layers that may be declared: `deployable-unit`, a configurable unit that ships, and `loose-fileset`, a
cross-cutting check surface that carries a demonstrated use, such as a pipeline, and deliberately overlaps the boundaries it cuts across.
Examples are a track's root concern like automation or infrastructure, a scan scope, and the reserved umbrellas. The third kind of layer,
`module`, is derived ([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)): the per-folder module partition plus the
`module-leftovers` catch-all. `GlobSet` accepts it as a layer, since `Get-ModuleGlobSet` constructs them, but `GlobsConfig` rejects it in
the declared registry. Within every layer but `loose-fileset` the sets are pairwise disjoint on own membership
([FDR-GLOBS-NOOVERLAPWITHINLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nooverlapwithinlayer)).

## The scan program

Membership is decided by the set's scan program
([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)): an ordered list of `+`/`-` rules
evaluated last match wins, with a default of not selected. A leaf set's program is its includes as `+` then its excludes as `-`, so the
excludes come last and win. A composing set's program is the composed sets' programs first (dependency order, deepest base first, each set
once), then its own rules last, so a set's own rules override its base and it can re-add a slice the base dropped.

The program drives everything downstream: `Matches` decides membership, `Get-GlobSetTrigger` projects it into vendor path filters, and the
durable SHA ([FDR-GLOBS-DURABLESHAIDENTITY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity)) is computed over
exactly what the program selects.

- **`ScanRule`** is one rule: `Select` true is `+` (select), false is `-` (drop)
  ([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)).
- **`ScanProgram()`** returns the flattened program
  ([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)/8). Identical rules are
  deduplicated keeping the last occurrence, which is harmless for last match wins and keeps a diamond compose from repeating rules. It is
  built lazily and cached; the cache is valid because the composed sets are immutable after `ResolveCompose`, which clears it.
- **`ResolveCompose`** is called by `GlobsConfig` after construction, with the referenced sets in compose order, and clears the cached
  program so it rebuilds against the resolved composition.

## Membership

- **`Matches`** evaluates the scan program last match wins, default not selected: a file belongs when its last matching rule is `+`
  ([FDR-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)).
- **`OwnMatches`** is own membership
  ([FDR-GLOBS-NOOVERLAPWITHINLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nooverlapwithinlayer)): the set's own program
  only, its includes as `+` then its excludes as `-`, with compose ignored. That is the slice the set maps independent of any base it
  composes: a file belongs when the set selects it without help from a base. The independence check per layer is defined on this, never on
  effective (`Matches`) membership, because compose means depends on a base, a deliberate cross-layer overlap and not a peer overlap.
- **`SelectMembers`** returns the members of a tracked-file universe (`git ls-files`, fetched once by the caller and passed in) that the set
  selects, in ordinal order: one call per set instead of one `Matches` call per path from PowerShell. The universe is never cached here,
  since staging changes it.
- **`SelectOwnMembers`** is the same for own membership, in ordinal order, and is the per-layer independence check's input
  ([FDR-GLOBS-NOOVERLAPWITHINLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nooverlapwithinlayer)).
