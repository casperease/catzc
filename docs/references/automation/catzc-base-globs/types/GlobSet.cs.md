---
catzc:
  immutable:
    with_body_sha: e46532d94541
    path: docs/references/automation/catzc-base-globs/types/GlobSet.cs.md
    folder: docs/references/automation/catzc-base-globs/types
    name: glob-set-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-FLOW-CD-GLOBS#{4,5,7,8,10}
---

# automation/Catzc.Base.Globs/types/GlobSet.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One named globset: an area-of-control's mapping onto files under version control — a kebab-case name, a
description, its layer (deployable-unit | loose-fileset,
[ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7); the derived module layer never
appears in the registry), the authored include/exclude patterns, and the optional composition
([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)). Membership is decided by the set's SCAN PROGRAM
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): an ordered list of +/- rules
evaluated last-match-wins with a default of not-selected. A leaf set's program is its includes as '+' then
its excludes as '-' (excludes come last and win). A composing set's program is the composed sets' programs
first (dependency order, deepest base first, each set once), then its own +/- rules LAST — so a set's own
rules override its base (it re-adds a slice the base dropped). The program drives everything downstream:
Matches() decides membership, Get-GlobSetTrigger projects it into vendor path filters, and the durable SHA
([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)) is computed over exactly what the program selects.
Verify (test blast-radius scope) and Pipeline (the trigger-role binding) are declarative meta annotations.
A globset never composes itself and the compose graph is acyclic
([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)), which GlobsConfig asserts
across the whole registry at construction.
Per-layer independence ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)) is decided on OWN
membership (OwnMatches — the set's own rules only,
compose ignored): within a non-loose layer no two sets may select a common file on their OWN contribution.
See [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md).
```

## comment:2

Above `public static readonly string[] DeclaredLayers = { "deployable-unit",...`, written with `//`.

```text
The layers ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)) — three kinds of thing:
'deployable-unit' (a configurable unit that ships) and
'loose-fileset' (a cross-cutting check surface — a track's root concern like automation/infrastructure,
a scan scope, the reserved umbrellas — that carries a demonstrated use, e.g. a pipeline, and deliberately
overlaps the boundaries it cuts across). 'module' is the DERIVED layer
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)) — the per-folder
module partition plus the 'module-leftovers' catch-all — a valid GlobSet layer (Get-ModuleGlobSet
constructs them), but GlobsConfig rejects it in the declared registry. Within every layer but
'loose-fileset' the sets are pairwise-disjoint on OWN membership
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)).
```

## comment:3

Above `private IReadOnlyList<ScanRule> cachedProgram;`, written with `//`.

```text
The flattened scan program, built lazily from composed + own rules and cached (composed is immutable
after ResolveCompose, which clears this). One rule: select (+) or drop (-) a pattern.
```

## comment:4

Above `public readonly struct ScanRule`, written with `//`.

```text
A single scan-program rule
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): Select true = '+' (select), false = '-' (drop).
```

## comment:5

Above `internal void ResolveCompose(IReadOnlyList<GlobSet> resolved)`, written with `//`.

```text
Called by GlobsConfig after construction, with the referenced sets in Compose order. Clears the cached
program so it rebuilds against the resolved composition.
```

## comment:6

Above `public bool Matches(string repoRelativePath)`, written with `//`.

```text
Membership ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): evaluate the scan program
last-match-wins, default not-selected — a file
belongs when its last matching rule is '+'.
```

## comment:7

Above `public bool OwnMatches(string repoRelativePath)`, written with `//`.

```text
OWN membership ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)): the set's own program only —
its includes as '+' then its excludes as
'-', last-match-wins — with compose IGNORED. This is the set's OWN contribution, the slice it maps
independent of any base it composes: a file belongs when the set selects it without help from a base.
The per-layer independence gate is defined on this, never on effective (Matches) membership — compose
is "depends on a base," a deliberate cross-layer overlap, not a peer overlap.
```

## comment:8

Above `public string[] SelectMembers(IReadOnlyList<string> tracked)`, written with `//`.

```text
The members of a tracked-file universe (`git ls-files`, fetched once by the caller and passed in — never
cached here, since staging changes it) that the set selects (Matches), in ordinal order: one call per set
instead of one Matches call per path from PowerShell.
```

## comment:9

Above `public string[] SelectOwnMembers(IReadOnlyList<string> tracked)`, written with `//`.

```text
The OWN members (OwnMatches, compose ignored) of a tracked-file universe, in ordinal order — the per-layer
independence check's input ([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)).
```

## comment:10

Above `public IReadOnlyList<ScanRule> ScanProgram()`, written with `//`.

```text
The flattened scan program ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)/8): the composed sets'
programs first (dependency order,
deepest base first), then this set's own rules (includes as '+', excludes as '-') LAST, so own rules
override the base. Identical (op, pattern) rules are deduped keeping the LAST occurrence — harmless for
last-match-wins and keeps a diamond compose from repeating rules. Built lazily and cached.
```
