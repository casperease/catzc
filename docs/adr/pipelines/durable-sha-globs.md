# ADR: Durable-SHA markers — areas-of-control as version-controlled state

## Rules: ADR-GLOBS

### Rule ADR-GLOBS:1

One source of truth: named globsets in `globs.yml` (owned by `Catzc.Base.Globs`) map each area-of-control — a deployable unit, a track
(`ADR-TRACK`), or a scan scope — onto its files under version control. Each set's identity is persisted as its **sha-marker**
`.sha-markers/<name>.yml`. The marker is the mechanism; **trigger** is the name of one _role_ it plays: pipelines, workflows, and
build-validation policies path-filter only on the marker file, never on source paths. Its other roles are the PR surface (the changed
markers are the first thing a PR shows) and test blast-radius (protection scoping derives from the same identities).

- [One configuration point](#one-configuration-point)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-GLOBS:2

A pattern is repo-relative and `/`-separated. `**` is the only cross-segment operator and matches zero or more whole segments; a segment is
either exactly `**` or contains no `**`. Within a segment, semantics are exactly PowerShell wildcards (`*`, `?`, `[abc]`, `[a-z]`) as
implemented by `System.Management.Automation.WildcardPattern`, matched case-sensitively.

- [The dialect](#the-dialect)

### Rule ADR-GLOBS:3

A pattern containing `\`, a leading `/`, an empty segment, a `.` or `..` segment, or a backtick is rejected at config load. The dialect has
no escape character: every pattern must be expressible without one.

- [The dialect](#the-dialect)

### Rule ADR-GLOBS:4

A globset selects from tracked files only (`git ls-files`, the non-gitignored universe). Membership is decided by an ordered **scan
program**: a sequence of `+ <pattern>` (select) and `- <pattern>` (drop) rules, evaluated **last-match-wins** with a default of not-selected
— a file belongs when its last matching rule is `+`, and to no set when nothing matches. Precedence is position, not kind: a later rule
overrides an earlier one, so negation is expressed by order, never by an inline `!`. A leaf set's program is its `include:` patterns as `+`
then its `exclude:` patterns as `-` — excludes come last and win, the include-minus-exclude special case.

- [The matching universe](#the-matching-universe)

### Rule ADR-GLOBS:5

A globset's identity is its durable SHA: per member file, SHA-256 over the CR-stripped bytes; the per-file digests folded as
`<repo-relative-path>|<digest>` lines, ordinal-sorted by path, into one combined SHA-256. The marker file carries that digest as its
`sha256:` line, inside the full-information YAML of ADR-GLOBS:9.

- [The durable SHA](#the-durable-sha)

### Rule ADR-GLOBS:6

A commit that changes any file a globset matches also carries that globset's regenerated sha-marker file. A stale, missing, or orphaned
marker file fails the integrity gate. No globset may have a marker file (`.sha-markers/*.yml`) as a member: marker files are outputs of the
hash, never inputs. The config itself is an ordinary tracked file — a globset may include it, and the repository-wide CI set does, so a
config edit is never uncovered. A corollary is the PR surface: because the markers ride with every change and `.sha-markers/` is a
dot-folder that sorts to the top of a PR's file view, the marker diff IS the change's area-of-control report — no extra machinery.

- [Commit discipline](#commit-discipline)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-GLOBS:7

Every globset carries a **layer** — the kind of thing it maps. Two are declared in `globs.yml`: `deployable-unit` (a configurable unit that
ships) and `loose-fileset` (a cross-cutting check surface that deliberately overlaps the boundaries it cuts across — a track's root concern
(`ADR-TRACK`) such as `automation`/`infrastructure`, a scan scope, a reserved umbrella). A loose-fileset must earn its place by a
**demonstrated use** — a pipeline it triggers, a scan it scopes, a protection it drives (YAGNI: no catch-all-for-completeness's-sake). The
third, `module`, is **derived-only** (`ADR-PROTGLOB`): the folders are the registration, declaring it is rejected, and the layer carries the
per-folder module sets plus the `module-leftovers` catch-all (module-space files no module owns); derived sets persist sha-markers through
the same mechanism as declared sets (`ADR-PROTGLOB#7`).

A deployable unit takes one of two shapes: a **configured** unit — a base plus its own configuration, e.g. a customer or platform unit — and
a **base** unit — a shared, un-configured surface that exists only to be composed, e.g. `template-azure-subscription-foundation`, which
ships only through the configured units that compose it yet still carries an area-of-control (its `verify:` scope and its review surface).

Within every layer but `loose-fileset` the sets are pairwise-independent on OWN contribution (`ADR-GLOBS:10`): a module never consumes
another module's files, a unit never another unit's — each is a boundary. The `module` layer carries a **catch-all** (`module-leftovers`) so
it covers its whole space with nothing unmapped; the catch-all is the complement of the explicit sets, hence still disjoint from them.
`pipeline:` (the 1-1 trigger-role binding) and `verify:` (`modules` + `level`, the test blast-radius scope) are **orthogonal** annotations
valid on any layer: a CI pipeline binds a loose-fileset track's marker, a CD pipeline a configured deployable-unit's, a base unit binds
none. A **deployable-unit** that is neither composed nor pipeline-bound is not a unit but phantom state, and one living version
(`ADR-ONELIVE`) forbids it; a loose-fileset without a demonstrated use is likewise forbidden — every marker earns its cost (`ADR-GLOBS:9`).

- [One configuration point](#one-configuration-point)

### Rule ADR-GLOBS:8

A globset may **compose** other declared sets (`compose:`): its scan program (ADR-GLOBS:4) is the composed sets' programs first — in
dependency order, deepest base first, each set once — then the set's own `+`/`-` rules **last**, so the set's own rules override its base. A
unit re-adds a slice its base dropped exactly this way (`+ configuration/apex/**` after the base's `- configuration/*/**`). References
resolve to declared sets only, never to the set itself, and the reference graph must be acyclic — all validated at config load. Composition
is how a configured deployable-unit shares a base (e.g. every customer/platform unit composing `template-azure-subscription-foundation`, the
config-free foundation surface) without one deployment's configuration change firing another's pipeline. The flattened program is the
marker's core (ADR-GLOBS:9): the marker states exactly the ordered rules the tree is scanned with, no reference-chasing.

- [One configuration point](#one-configuration-point)

### Rule ADR-GLOBS:9

The marker file is the fileset's **immutable lock** — two reproducible core parts under a meta header: (1) the `scan:` program, the ordered
`+`/`-` rules the non-gitignored tree is scanned with (ADR-GLOBS:4, flattened through compose per ADR-GLOBS:8), and (2) the final `sha256:`
line, the durable SHA of exactly what that scan selected (ADR-GLOBS:5). The **meta** above them — name, description, layer, pipeline,
verify, compose — is provenance: what the mapping represents and how the program was derived, never an input to the hash. Fixed field order
(name, description, layer, pipeline, verify, compose, scan, sha256), LF-terminated, patterns single-quoted, empty meta sections omitted.
`program → fileset → sha` is deterministic with nothing else as input, and the file parses both ways. The `GlobSet` type produces the
content (`Representation` + `MarkerContent(sha)`), and `Update-ShaMarker` writes it only on a real content change — so the one file
separates two signals in its diff: the `scan:` body changes when the **definition** changes (its own rules, or a composed set's), the
`sha256:` line whenever selected **content** changes. The file is data our own tooling can parse back (the repository's `.yml` convention),
never an input to any hash (ADR-GLOBS:6).

- [The marker is an immutable lock](#the-marker-is-an-immutable-lock)

### Rule ADR-GLOBS:10

Within a layer, no two globsets may select a common file on their **OWN contribution** — the set's own `include`/`exclude` program with
`compose` ignored (`ADR-GLOBS:4`). Two that do contain parts of each other and are not independent — the boundary leaks. Validation is **per
layer, never across**: a deployable-unit deliberately contains the base it composes, and every file sits in both a `track` and a `module`,
so cross-layer overlap is expected and correct — the rule is defined on OWN membership within one layer, never on effective membership or
across layers. The `track`, `deployable-unit`, and `module` layers are each pairwise-disjoint on OWN membership; the `loose-fileset` layer
is **exempt** — its sets are cross-cutting surfaces (scan scopes, the reserved umbrellas `internal`/`vendor`/`compiled`/`scriptanalyzer`)
that overlap the boundaries they cut across by design. A catch-all (`repository`, `module-leftovers`) is the complement of its layer's
explicit sets, so it satisfies the rule by construction. The rule holds across the declared registry and the derived module sets
(`ADR-PROTGLOB:7`) alike; a violation names both sets and a shared file.

- [Per-layer independence](#per-layer-independence)

## Context

A deployable unit is a high-level composition of modules in the modular repository — a whole track or a reduced slice of one (see
[tracks](../design/tracks.md), `ADR-TRACK#5`) — mapped onto actual files under version control. Both Azure DevOps (`trigger:`/`pr:`
`paths:`, build-validation policies) and GitHub (`on.*.paths`) decide whether to run by matching changed paths against filter lists. Writing
those lists directly into every pipeline and workflow scatters one fact — "which files compose this unit" — across the orchestration layer,
in two vendor dialects with subtly different wildcard semantics, where drift is invisible until a deploy silently does not fire.

The durable-SHA design inverts this: the composition is declared once, at the deterministic source-of-truth layer, and each unit's identity
is materialized as a committed hash — its sha-marker. Orchestration artifacts hold a registration — a single-path filter on the marker file
— and nothing else.

## Decision

### One configuration point

`globs.yml` holds every globset: a kebab-case name, a description, its layer (`ADR-GLOBS:7`), an `include:` pattern list and optional
`exclude:` list, optional `compose:` references (`ADR-GLOBS:8`), an optional `verify:` blast-radius scope, and — on a configured
deployable-unit — the `pipeline:` it binds (a base unit composed by others binds none, `ADR-GLOBS:7`). `Catzc.Base.Globs` owns the file, the
dialect, the hash, and all reading and writing of `.sha-markers/`; nothing else parses the config or writes into that folder. A pipeline or
workflow references a unit by registering the unit's marker path as its only path filter, so adding or removing files from a unit — or
adding a whole customer — is a config edit, never an orchestration edit.

### The dialect

Vendor path-filter dialects are irrelevant here: matching happens in our own code against the tracked-file list, and the vendors only ever
see the marker path. That frees the dialect to be the one this repository's users already know — within a segment, a pattern means exactly
what it means to PowerShell's `-like` operator, delegated to `System.Management.Automation.WildcardPattern` (a host-guaranteed type; see
[native-csharp-types](../automation/BCL/native-csharp-types.md)). Matching is case-sensitive because tracked paths are case-sensitive
identities.

`**` is the single addition, and the only operator that crosses `/`: it stands as a whole segment and consumes zero or more whole segments.

| Pattern               | Matches                              | Does not match              |
| --------------------- | ------------------------------------ | --------------------------- |
| `automation/**`       | `automation/a.ps1`, `automation/x/y` | `automation2/a.ps1`         |
| `**/*.md`             | `README.md`, `docs/adr/index.md`     | `docs/adr` (a folder)       |
| `pipelines/ci-*.yaml` | `pipelines/ci-automation.yaml`       | `pipelines/steps/ci-x.yaml` |
| `**/tests/**/*.ps1`   | `automation/M/tests/a.Tests.ps1`     | `automation/M/a.ps1`        |

Hygiene is structural (`ADR-POKA`): separators are `/` only, patterns are repo-relative (no leading `/`), no `.`/`..` segments, and no
backtick — `WildcardPattern` treats the backtick as an escape character, and an escape character in a path pattern signals a mistake, so the
config loader rejects it rather than letting escape semantics leak into the dialect.

### The matching universe

Patterns select from the output of `git ls-files` — the set of tracked files. This is the literal meaning of "files under version control":
deterministic on every checkout, independent of build residue, and governed by the repository's own definition of what exists. An untracked
or ignored file can never change a globset's membership or its hash.

### The durable SHA

The hash recipe makes the identity durable across platforms and sensitive to everything that matters:

- **EOL-insensitive.** CR bytes are stripped before hashing each file, so Windows and Linux checkouts agree.
- **Path-folded.** Each file contributes `<repo-relative-path>|<digest>`, so a rename or move changes the identity even when content does
  not — a moved file changes what a unit deploys.
- **Order-free.** Lines are ordinal-sorted by path before the combined digest, so enumeration order is irrelevant.

### The marker is an immutable lock

The marker file `.sha-markers/<name>.yml` is the fileset's lock — a meta header plus the two deterministic core parts. The **meta** (name,
description, layer, pipeline, verify, compose) is provenance: what the mapping represents and how its program was derived. The **core** is a
`scan:` block — the ordered `+`/`-` program the tree is scanned with, flattened through compose (ADR-GLOBS:4/8) so it needs no
reference-chasing — and a final `sha256:` line, the durable SHA of exactly what that scan selected. The `GlobSet` type renders all of it
deterministically (empty meta sections omitted, patterns single-quoted). So a customer unit's marker shows, in one file, the full ordered
program it inherits from its base plus the rules it adds on top, and the identity of the resulting fileset. One file, two separable signals
in review: a diff in the `scan:` body means the definition changed — a rule added, a pipeline rebound, or a composed set's rules changed; a
diff in the `sha256:` line means the selected content changed. A reader (or a tool) can parse the marker as ordinary YAML both ways —
program → fileset, fileset → sha — and know the unit's definition and identity without opening `globs.yml`. `.gitattributes` pins the line
ending, so the bytes are identical on every checkout.

### Per-layer independence

A layer is a set of peers that partition one concern into boundaries: the `track` layer partitions the tree at the root, the `module` layer
partitions module-space, the `deployable-unit` layer partitions what ships. Overlap between peers means one boundary consumes another's
files, and the marker diff stops being a clean area-of-control report. So within a layer the sets are pairwise-disjoint — but on their
**OWN** contribution, never their effective membership (`ADR-GLOBS:10`). The distinction is what makes `compose` legal: a customer
deployable-unit's _effective_ members include the whole base it composes, so on effective membership every customer overlaps the base and
each other through it. That overlap is the point of composition — "depends on a base" — not a peer collision. On OWN membership (compose
ignored) the customer units own only their own `configuration/<key>/**` slice and the base owns the shared surface minus the config folders,
so the layer is disjoint. The same holds across layers by design: a file under `automation/Catzc.Base.Globs/` belongs to the `automation`
track AND the `catzc-base-globs` module AND (if it ships) a deployable-unit — three boundaries in three layers, one file. Cross-layer
overlap is never a violation; only same-layer overlap is.

Catch-alls keep a layer total without breaking disjointness. The `repository` track owns every root file `automation`/`infrastructure` do
not — the complement — so it can never overlap them; add a track and its files leave `repository` automatically, but only if the new track
is also excluded there, which the gate checks. The `module-leftovers` set is the module-space complement: it should be empty in a clean
tree, a tripwire for a file dropped at `automation/`'s root or a folder not yet a module. The `loose-fileset` layer is exempt because its
sets are defined to cut across the boundaries: the reserved `internal` umbrella covers the same files as the per-`.psm1` `catzc-internal-*`
module sets; a scan scope like markdown spans every track. These are deliberate cross-sections, not independent peers, so the rule does not
police them. The gate evaluates OWN membership over the tracked-file universe for the declared registry and the derived module sets
together, so a mis-scoped module include, a track that reaches into another's files, or an umbrella mistakenly declared a `module` fails as
a named pair.

### Registering a pipeline or workflow

Registration is one line per vendor: the unit's marker path as the only path filter. The vendors' own glob dialects never appear — a marker
file is a literal path, so nothing is left for their `*`/`**` semantics to disagree about.

An Azure DevOps root pipeline (the `trigger:`/`pr:` keys are honored only at the pipeline root, never inside a template):

```yaml
trigger:
  branches:
    include: [main]
  paths:
    include: [.sha-markers/<globset>.yml]

pr:
  branches:
    include: [main]
  paths:
    include: [.sha-markers/<globset>.yml]
```

A GitHub workflow:

```yaml
on:
  push:
    branches: [main]
    paths: [.sha-markers/<globset>.yml]
  pull_request:
    branches: [main]
    paths: [.sha-markers/<globset>.yml]
```

An ADO build-validation policy lives server-side, not in the repository: its path filter is set to `/.sha-markers/<globset>.yml` in the
branch policy. The policy is a registration like any other — the unit's composition still lives only in `globs.yml`.

A pipeline whose scope spans several units registers several marker files (a list of paths); a pipeline whose unit is effectively the whole
repository registers the repository-wide set's marker rather than dropping the filter — dropping it would put marker-only edge cases and
vendor default semantics back in play. Because the marker changes exactly when the unit's durable SHA changes, a registration is
behaviorally identical to a perfect source-path filter — including renames and moves, which content-blind vendor filters miss.

### Commit discipline

Vendor triggers fire on changed paths in a push. The marker file is what turns "this unit changed" into a changed path: whoever changes a
member file regenerates the marker (`Update-ShaMarker` — on a dev box the importer's janitor does it, and commits it, by default) and lands
both together. The integrity gate makes the discipline self-enforcing — a stale marker fails CI, so the only way to land a unit change is to
also land its new identity. The self-exclusion rule keeps regeneration stable: writing a marker file never changes any globset's input, so
one pass always converges.

### How this is enforced

- `GlobsConfig` validates the schema and every pattern at config load, rejecting unknown keys, malformed patterns (`ADR-GLOBS:3`), and
  self-matching globsets (`ADR-GLOBS:6`).
- `Test-ShaMarker` recomputes every globset's durable SHA and reports stale, missing, and orphaned marker files; an integrity-tagged test in
  `Catzc.Base.Globs` asserts it, so `Test-Automation` fails locally and in CI on any violation.
- `Test-GlobSetIndependence` evaluates OWN membership per layer across the declared registry and the derived module sets, reporting any
  same-layer pair that overlaps (`ADR-GLOBS:10`); a second integrity-tagged test asserts it empty, so a module or deployable-unit that
  starts containing part of a peer fails the same gate.
- Grep-ability: `paths:` filters in `pipelines/*.yaml` and `.github/workflows/` reference only `.sha-markers/` entries; a source path in a
  filter is findable by search and wrong by rule (`ADR-GLOBS:1`).

## Consequences

- One edit point: recomposing a deployable unit touches `globs.yml`, never N pipelines in two vendor dialects.
- Reviewable deploys: "this commit re-deploys unit X" is a visible one-line diff under `.sha-markers/` — sorted to the top of the PR's file
  view, so the areas-of-control a change touches are the first thing a reviewer sees.
- The identity is reproducible from any checkout: same tracked content, same SHA, on every platform.
- Contributors carry a duty to regenerate marker files (the dev-box importer janitor carries it for them); the gate converts forgetting from
  a silent non-deploy into a red build.
- Renames and moves re-trigger by construction, which vendor content-blind path filters get right only by accident.

## Related

- [pipeline-types](pipeline-types.md) — the per-kind trigger contracts that register on marker files
- [tracks](../design/tracks.md) — the root concerns whose subscription surface the markers are
- [ci-discipline-and-promotion-flow](../design/ci-discipline-and-promotion-flow.md) — the deployable unit's role in CD/CDE governance
- [native-csharp-types](../automation/BCL/native-csharp-types.md) — the host-guaranteed type set the dialect implementation draws on
- [everything-as-code](../principles/everything-as-code.md), [poka-yoke](../principles/poka-yoke.md),
  [reduce-variability](../principles/reduce-variability.md) — the principles this mechanism instantiates

## Dora explains

DORA's research links version-controlled infrastructure and deterministic deployment triggering to faster, more reliable deployments. This
ADR's design of durable-SHA markers as the single source of truth for area-of-control boundaries reduces deployment drift, makes CI trigger
points reviewable as a first-class concern, and eliminates the maintenance tax of scattered path filters across two vendor dialects.

- [Version control](https://dora.dev/capabilities/version-control/) — area-of-control boundaries as committed state, the single
  configuration point.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — deterministic, reproducible marker-based triggering.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — one unit change regenerates one marker, visible as a
  focused diff.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
