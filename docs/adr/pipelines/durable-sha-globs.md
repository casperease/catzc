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

A globset selects from tracked files only (`git ls-files`). Membership is `include:` minus `exclude:` — a file belongs to the set when it
matches at least one include pattern and no exclude pattern. There is no inline negation.

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

Every declared globset carries a **layer**: `track` (a root concern, `ADR-TRACK`), `deployable-unit` (a configurable unit that ships —
optionally bound 1-1 to a CI/CD pipeline, annotated on the set as `pipeline:`), or `scope` (a cross-cutting slice). A deployable unit takes
one of two shapes: a **configured** unit — a base plus its own configuration, e.g. a customer or platform unit — binds its pipeline; a
**base** unit — a shared, un-configured surface that exists only to be composed, e.g. `template-azure-subscription-foundation` — binds none,
because it ships only through the configured units that compose it, yet still carries an area-of-control (its `verify:` scope and its review
surface). A globset that is neither composed nor pipeline-bound is not a unit but phantom state, and one living version (`ADR-ONELIVE`)
forbids it. The fourth layer, `module`, is **derived-only** (`ADR-PROTGLOB`) — the folders are the registration, and declaring it is
rejected; derived module sets persist sha-markers through the same mechanism as declared sets (`ADR-PROTGLOB#7`), while pipelines register
only on declared deployable-unit markers. An optional `verify:` (`modules` + `level`) declares the set's test blast-radius scope.

- [One configuration point](#one-configuration-point)

### Rule ADR-GLOBS:8

A globset may **compose** other declared sets (`compose:`): its effective membership is its own include-minus-exclude members UNION the
composed sets' effective members. References resolve to declared sets only, never to the set itself, and the reference graph must be acyclic
— all validated at config load. Composition is how a configured deployable-unit shares a base (e.g. every customer/platform unit composing
`template-azure-subscription-foundation`, the config-free foundation surface) without one deployment's configuration change firing
another's pipeline. The composed surface is also rendered
into the marker's `resolved:` block (ADR-GLOBS:9), so the marker states a set's effective membership without chasing references.

- [One configuration point](#one-configuration-point)

### Rule ADR-GLOBS:9

The marker file is **full-information YAML**: the globset's canonical, LF-terminated definition representation (fixed field order — name,
description, layer, pipeline, verify, compose, include, exclude, resolved — empty sections omitted, patterns single-quoted) plus a final
`sha256:` line carrying the durable SHA of ADR-GLOBS:5. When the set composes (ADR-GLOBS:8), the trailing `resolved:` block expands the
effective composed surface — every transitively composed set that carries its own patterns, rendered under its name with its own
`include`/`exclude` kept together (never flattened into one table: a flat merge would leak one set's exclude onto another's include and
change what the set matches). The `resolved:` block is a display of the union `Matches()` already computes; it makes the marker state what
the set contains without chasing `compose:` references into other marker files. The `GlobSet` type produces the content (`Representation` +
`MarkerContent(sha)`), and `Update-ShaMarker` writes it only on a real content change — so the one file separates the two signals in its
diff: body lines change exactly when the set's **definition** changes — its own, or (through `resolved:`) a composed set's — the `sha256:`
line whenever member **content** changes. The file is data our own tooling can parse back (the repository's `.yml` convention), never an
input to any hash (ADR-GLOBS:6).

- [The marker is full-information YAML](#the-marker-is-full-information-yaml)

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
deployable-unit — the `pipeline:` it binds (a base unit composed by others binds none, `ADR-GLOBS:7`). `Catzc.Base.Globs` owns the file,
the dialect, the hash, and all reading and writing of `.sha-markers/`; nothing
else parses the config or writes into that folder. A pipeline or workflow references a unit by registering the unit's marker path as its
only path filter, so adding or removing files from a unit — or adding a whole customer — is a config edit, never an orchestration edit.

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

### The marker is full-information YAML

The marker file `.sha-markers/<name>.yml` holds everything there is to say about the set: its canonical definition — name, description,
layer, pipeline, verify, compose, include, exclude, rendered deterministically by the `GlobSet` type with empty sections omitted and
patterns single-quoted — a `resolved:` block that expands any composed surface (ADR-GLOBS:9), and, as the final line, `sha256:` with the
durable SHA above. The `resolved:` block lists each transitively composed set that contributes patterns, its `include`/`exclude` kept
together under its name — a faithful picture of the effective union (never a flat merge, which would drop the composing set's own
configuration by leaking the base's excludes onto it). So a customer unit's marker shows, in one file, both what the customer adds and the
shared base it inherits. One file, two separable signals in review: a diff in the body means the set's composition changed — a pattern
added, a pipeline rebound, or a composed set's patterns changed; a diff in the `sha256:` line means the members' content changed. A reader
(or a tool) can parse the marker as ordinary YAML and know the unit's definition and identity without opening `globs.yml`.
`.gitattributes` pins the line ending, so the bytes are identical on every checkout.

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
