# ADR: Globset triggers — areas-of-control projected to native filters and reflected from git

## Rules: ADR-FLOW-CD-GLOBS

### Rule ADR-FLOW-CD-GLOBS:1

One source of truth: named globsets in `globs.yml` (owned by `Catzc.Base.Globs`) map each area-of-control — a deployable unit, a track
(`ADR-DSGN-TRACK`), or a scan scope — onto its files under version control. The globset is the mechanism; it plays three roles, all
**derived** and **none committed per set**: the **trigger** — pipelines, workflows, and build-validation policies path-filter on the
globset's native projection (`Get-GlobSetTrigger`), never on a committed marker; the **PR area-of-control report** — the sets a change
touches, computed from git (`Get-ChangedGlobSet`); and **test blast-radius / protection** — scoping derives from the same identities
(`ADR-REPO-PROTGLOB`).

- [One configuration point](#one-configuration-point)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-FLOW-CD-GLOBS:2

A pattern is repo-relative and `/`-separated. `**` is the only cross-segment operator and matches zero or more whole segments; a segment is
either exactly `**` or contains no `**`. Within a segment, semantics are exactly PowerShell wildcards (`*`, `?`, `[abc]`, `[a-z]`) as
implemented by `System.Management.Automation.WildcardPattern`, matched case-sensitively.

- [The dialect](#the-dialect)

### Rule ADR-FLOW-CD-GLOBS:3

A pattern containing `\`, a leading `/`, an empty segment, a `.` or `..` segment, or a backtick is rejected at config load. The dialect has
no escape character: every pattern must be expressible without one.

- [The dialect](#the-dialect)

### Rule ADR-FLOW-CD-GLOBS:4

A globset selects from tracked files only (`git ls-files`, the non-gitignored universe). Membership is decided by an ordered **scan
program**: a sequence of `+ <pattern>` (select) and `- <pattern>` (drop) rules, evaluated **last-match-wins** with a default of not-selected
— a file belongs when its last matching rule is `+`, and to no set when nothing matches. Precedence is position, not kind: a later rule
overrides an earlier one, so negation is expressed by order, never by an inline `!`. A leaf set's program is its `include:` patterns as `+`
then its `exclude:` patterns as `-` — excludes come last and win, the include-minus-exclude special case.

- [The matching universe](#the-matching-universe)

### Rule ADR-FLOW-CD-GLOBS:5

A globset's **identity** is its durable SHA: per member file, SHA-256 over the CR-stripped bytes; the per-file digests folded as
`<repo-relative-path>|<digest>` lines, ordinal-sorted by path, into one combined SHA-256. This identity is computed **live**
(`Get-GlobSetHash`) and is **never committed**: it keys the session-memory protection map (`ADR-REPO-PROTGLOB`) and answers "did these
inputs change?" for the local inner loop. It is not a trigger and not a committed artifact — a committed whole-set hash is a lockfile that
serializes writers and false-reds a busy mainline after a server-side squash merge, which is why triggering projects to native filters
(ADR-FLOW-CD-GLOBS:6) and reflects git (ADR-FLOW-CD-GLOBS:9) instead.

- [Why the identity is live, never committed](#why-the-identity-is-live-never-committed)

### Rule ADR-FLOW-CD-GLOBS:6

A pipeline, workflow, or build-validation policy triggers on the globset's **native path-filter projection** (`Get-GlobSetTrigger`): the
flattened scan program (ADR-FLOW-CD-GLOBS:4/8) rendered into the vendor's own `paths` dialect — GitHub `on.*.paths` with ordered `!`
negation (exact, the same last-match-wins evaluator as `GlobSet.Matches`); Azure DevOps `trigger.paths.include`/`exclude` and branch-policy
`filenamePatterns` (order-independent — union include minus union exclude — so each pattern is collapsed to its last select, and a compose
re-add becomes a deeper-folder include ADO keeps). Modern vendors (ADO Services / Server 2022+, GitHub) accept wildcards anywhere in a path
filter, so the projection is a true no-start trigger. The projected filters are generated from `globs.yml`, never hand-authored, and the
drift gate (`Test-AdoPipelineTriggerGlob` / `Test-GitHubWorkflowTriggerGlob`) fails a pipeline whose declared trigger no longer equals its
projection.

- [Native projection: the no-start trigger](#native-projection-the-no-start-trigger)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-FLOW-CD-GLOBS:7

Every globset carries a **layer** — the kind of thing it maps. Two are declared in `globs.yml`: `deployable-unit` (a configurable unit that
ships) and `loose-fileset` (a cross-cutting check surface that deliberately overlaps the boundaries it cuts across — a track's root concern
(`ADR-DSGN-TRACK`) such as `automation`/`infrastructure`, a scan scope, a reserved umbrella). A loose-fileset must earn its place by a
**demonstrated use** — a pipeline it triggers, a scan it scopes, a protection it drives (YAGNI: no catch-all-for-completeness's-sake). The
third, `module`, is **derived-only** (`ADR-REPO-PROTGLOB`): the folders are the registration, declaring it is rejected, and the layer
carries the per-folder module sets plus the `module-leftovers` catch-all (module-space files no module owns); derived sets scope protection
and blast-radius through the same `Matches()` machinery as declared sets (`ADR-REPO-PROTGLOB#7`), with nothing committed per set.

A deployable unit takes one of two shapes: a **configured** unit — a base plus its own configuration, e.g. a customer or platform unit — and
a **base** unit — a shared, un-configured surface that exists only to be composed, e.g. `template-azure-subscription-foundation`, which
ships only through the configured units that compose it yet still carries an area-of-control (its `verify:` scope and its review surface).

Within every layer but `loose-fileset` the sets are pairwise-independent on OWN contribution (`ADR-FLOW-CD-GLOBS:10`): a module never
consumes another module's files, a unit never another unit's — each is a boundary. The `module` layer carries a **catch-all**
(`module-leftovers`) so it covers its whole space with nothing unmapped; the catch-all is the complement of the explicit sets, hence still
disjoint from them. `pipeline:` (the 1-1 trigger-role binding) and `verify:` (`modules` + `level`, the test blast-radius scope) are
**orthogonal** annotations valid on any layer: a CI pipeline binds a loose-fileset track's projection, a CD pipeline a configured
deployable-unit's, a base unit binds none. A **deployable-unit** that is neither composed nor pipeline-bound is not a unit but phantom
state, and one living version (`ADR-PRIN-ONELIVE`) forbids it; a loose-fileset without a demonstrated use is likewise forbidden — every
globset earns its cost.

- [One configuration point](#one-configuration-point)

### Rule ADR-FLOW-CD-GLOBS:8

A globset may **compose** other declared sets (`compose:`): its scan program (ADR-FLOW-CD-GLOBS:4) is the composed sets' programs first — in
dependency order, deepest base first, each set once — then the set's own `+`/`-` rules **last**, so the set's own rules override its base. A
unit re-adds a slice its base dropped exactly this way (`+ configuration/apex/**` after the base's `- configuration/*/**`). References
resolve to declared sets only, never to the set itself, and the reference graph must be acyclic — all validated at config load. Composition
is how a configured deployable-unit shares a base (e.g. every customer/platform unit composing `template-azure-subscription-foundation`, the
config-free foundation surface) without one deployment's configuration change firing another's pipeline. The flattened program is what both
the native projection (ADR-FLOW-CD-GLOBS:6) and the durable SHA (ADR-FLOW-CD-GLOBS:5) are computed from — no reference-chasing at trigger or
hash time.

- [One configuration point](#one-configuration-point)

### Rule ADR-FLOW-CD-GLOBS:9

Whether a change touches a unit is **computed from git at real refs**, never from a committed hash. `Get-ChangedGlobSet` diffs a commit
range (`Get-ChangedFile`, `git diff --name-only --no-renames`) and matches the changed paths against the registry; `Test-GlobSetAffected`
answers the in-pipeline "is there anything here for us to process?" gate, resolving the reference commit per context
(`Get-GlobSetChangeRange`: post-commit first-parent `HEAD^1..HEAD` — squash-safe; PR merge-base `origin/<target>...HEAD`; local working
tree) and **failing open** on any doubt so a wrong skip can never drop a deploy. The same computation is the PR area-of-control report.
Because it is recomputed at the actual refs after the merge exists, it is immune to the squash-merge and concurrent-merge staleness a
committed hash suffers, and correct across renames (a rename is split into both its paths). A pipeline must checkout with sufficient depth
(`fetchDepth: 0`) so the base ref is reachable.

- [Git reflection: the in-pipeline gate and the PR report](#git-reflection-the-in-pipeline-gate-and-the-pr-report)

### Rule ADR-FLOW-CD-GLOBS:10

Within a layer, no two globsets may select a common file on their **OWN contribution** — the set's own `include`/`exclude` program with
`compose` ignored (`ADR-FLOW-CD-GLOBS:4`). Two that do contain parts of each other and are not independent — the boundary leaks. Validation
is **per layer, never across**: a deployable-unit deliberately contains the base it composes, and every file sits in both a `track` and a
`module`, so cross-layer overlap is expected and correct — the rule is defined on OWN membership within one layer, never on effective
membership or across layers. The `track`, `deployable-unit`, and `module` layers are each pairwise-disjoint on OWN membership; the
`loose-fileset` layer is **exempt** — its sets are cross-cutting surfaces (scan scopes, the reserved umbrellas
`internal`/`vendor`/`compiled`/`scriptanalyzer`) that overlap the boundaries they cut across by design. A catch-all (`repository`,
`module-leftovers`) is the complement of its layer's explicit sets, so it satisfies the rule by construction. The rule holds across the
declared registry and the derived module sets (`ADR-REPO-PROTGLOB:7`) alike; a violation names both sets and a shared file.

- [Per-layer independence](#per-layer-independence)

## Context

A deployable unit is a high-level composition of modules in the modular repository — a whole track or a reduced slice of one (see
[tracks](../design/tracks.md), `ADR-DSGN-TRACK#5`) — mapped onto actual files under version control. Both Azure DevOps (`trigger:`/`pr:`
`paths:`, build-validation policies) and GitHub (`on.*.paths`) decide whether to run by matching changed paths against filter lists. Writing
those lists directly into every pipeline and workflow by hand scatters one fact — "which files compose this unit" — across the orchestration
layer, in two vendor dialects, where drift is invisible until a deploy silently does not fire.

The design keeps the composition declared once, at the deterministic source-of-truth layer (`globs.yml`), and derives everything else from
it. Two derivations replace what a committed per-set marker used to carry: the trigger is the globset **projected** into each vendor's
native path-filter dialect (`Get-GlobSetTrigger`), generated into the orchestration YAML and drift-checked against the source; and "did this
change touch the unit?" is **reflected** from git at the real refs (`Get-ChangedGlobSet` / `Test-GlobSetAffected`). Nothing is committed per
set, so there is no whole-set hash to go stale.

## Decision

### One configuration point

`globs.yml` holds every globset: a kebab-case name, a description, its layer (`ADR-FLOW-CD-GLOBS:7`), an `include:` pattern list and
optional `exclude:` list, optional `compose:` references (`ADR-FLOW-CD-GLOBS:8`), an optional `verify:` blast-radius scope, and — on a
configured deployable-unit — the `pipeline:` it binds (a base unit composed by others binds none, `ADR-FLOW-CD-GLOBS:7`). `Catzc.Base.Globs`
owns the file, the dialect, the durable SHA, the native projection, and the git-reflection query; nothing else parses the config. Adding or
removing files from a unit — or adding a whole customer — is a config edit; the projected triggers regenerate from it.

### The dialect

Vendor path-filter dialects need not leak into ours: membership is decided in our own code against the tracked-file list, and only the
**projection** (ADR-FLOW-CD-GLOBS:6) crosses into a vendor dialect, mechanically. That frees the authoring dialect to be the one this
repository's users already know — within a segment, a pattern means exactly what it means to PowerShell's `-like` operator, delegated to
`System.Management.Automation.WildcardPattern` (a host-guaranteed type; see
[native-csharp-types](../automation/BCL/native-csharp-types.md)). Matching is case-sensitive because tracked paths are case-sensitive
identities.

`**` is the single addition, and the only operator that crosses `/`: it stands as a whole segment and consumes zero or more whole segments.

| Pattern               | Matches                              | Does not match              |
| --------------------- | ------------------------------------ | --------------------------- |
| `automation/**`       | `automation/a.ps1`, `automation/x/y` | `automation2/a.ps1`         |
| `**/*.md`             | `README.md`, `docs/adr/index.md`     | `docs/adr` (a folder)       |
| `pipelines/ci-*.yaml` | `pipelines/ci-automation.yaml`       | `pipelines/steps/ci-x.yaml` |
| `**/tests/**/*.ps1`   | `automation/M/tests/a.Tests.ps1`     | `automation/M/a.ps1`        |

Hygiene is structural (`ADR-PRIN-POKAYOKE`): separators are `/` only, patterns are repo-relative (no leading `/`), no `.`/`..` segments, and
no backtick — `WildcardPattern` treats the backtick as an escape character, and an escape character in a path pattern signals a mistake, so
the config loader rejects it.

### The matching universe

Patterns select from the output of `git ls-files` — the set of tracked files. This is the literal meaning of "files under version control":
deterministic on every checkout, independent of build residue, and governed by the repository's own definition of what exists. An untracked
or ignored file can never change a globset's membership.

### Why the identity is live, never committed

The durable SHA (ADR-FLOW-CD-GLOBS:5) is a genuine identity — EOL-insensitive (CR stripped before hashing), path-folded (a rename or move
changes it even when content does not), and order-free (lines ordinal-sorted). It is exactly right for the one job it keeps: keying the
session-memory protection map (`ADR-REPO-PROTGLOB`), where "this session already proved this input state green" is a live, in-process fact.

What it must **not** be is a committed artifact gating the mainline. A committed whole-set hash is a lockfile over that set: two pull
requests that touch different files of the same set both freeze the hash against their own branch state, and after a server-side squash
merge the mainline holds the union while each frozen hash saw only its own half — an integrity gate recomputing the set would red the
mainline with neither change individually wrong, and no merge conflict to warn anyone. Because the squash commit is a tree the client never
hashed, any client-frozen hash is suspect. So the identity stays live and local; the trigger is a native projection (ADR-FLOW-CD-GLOBS:6)
and the "did this change?" question is answered from git at the real refs (ADR-FLOW-CD-GLOBS:9), both of which see the merged tree as it
actually is.

### Native projection: the no-start trigger

`Get-GlobSetTrigger` projects a globset's flattened scan program (ADR-FLOW-CD-GLOBS:4/8) into each vendor's native path-filter dialect:

- **GitHub** `on.*.paths`: the program in order, each `-` rule rendered as a `!` negation. GitHub paths are ordered and last-match-wins —
  the same evaluator as `GlobSet.Matches` — so the projection is **exact**.
- **Azure DevOps** `trigger.paths.include`/`exclude` and branch-policy `filenamePatterns`: order-independent (union include minus union
  exclude), so each pattern is collapsed to its **last select** in the program — a base exclude a later compose include re-adds nets to an
  include, and ADO's documented "a deeper-folder include overrides a broader exclude" carries the compose re-add. Modern ADO (Services /
  Server 2022+) accepts wildcards anywhere in a path filter, so the projection is a real no-start trigger, not a start-then-bail.

The projected filters are **generated** from `globs.yml` into the orchestration YAML (the generated-root-config contract), never
hand-authored. A registration is therefore behaviourally the unit's real path filter — including renames and moves, which content-blind hand
filters miss — and the drift gate (`Test-AdoPipelineTriggerGlob` / `Test-GitHubWorkflowTriggerGlob`) fails any pipeline whose declared
trigger no longer equals its projection. The one semantic seam — ADO's order-independence versus our positional last-match-wins — coincides
for every folder-shaped set; a set whose ADO projection cannot reproduce exact membership is caught at generation time, not silently
mis-triggered.

An Azure DevOps root pipeline (the `trigger:`/`pr:` keys are honored only at the pipeline root, never inside a template):

```yaml
trigger:
  branches:
    include: [main]
  paths:
    include:
      - infrastructure/templates/foundation/**
      - infrastructure/modules/**
      - infrastructure/templates/foundation/configuration/apex/**
    exclude:
      - infrastructure/templates/foundation/configuration/*.yml
      - infrastructure/templates/foundation/configuration/*/**
```

A GitHub workflow (ordered, `!`-negation):

```yaml
on:
  push:
    branches: [main]
    paths: [automation/**]
  pull_request:
    branches: [main]
    paths: [automation/**]
```

An ADO build-validation policy lives server-side, not in the repository: its path filter is set to the same projection, `/`-anchored
(`Get-BuildValidationPathFilter`). The policy is a registration like any other — the unit's composition still lives only in `globs.yml`.

### Git reflection: the in-pipeline gate and the PR report

A native trigger is content-blind at the vendor's grain, and a coarse or over-approximating filter may start a run the unit doesn't actually
need. `Test-GlobSetAffected` is the exact backstop the pipeline runs first — "is there anything here for us to process?" — and the same
computation is the PR area-of-control report:

- `Get-GlobSetChangeRange` resolves the reference commit per context (`ADR-FLOW-CD-DETECT`): **post-commit on main** diffs first-parent
  `HEAD^1..HEAD` — main advances only by squash merge, so the merged commit's first parent is the prior mainline and the diff is exactly the
  push; **PR pre-commit** diffs the merge-base `origin/<target>...HEAD`; **local** diffs the working tree.
- `Get-ChangedGlobSet` matches the changed paths against the registry (declared, and with `-IncludeModules` the derived module sets), and
  `Test-GlobSetAffected` reports whether the named unit is among them.

It **fails open**: an unresolvable base (a shallow clone that cannot reach `HEAD^1`, a first commit, a target ref not yet fetched) proceeds
rather than skips, because a redundant run is safe and a wrong skip is an un-deployed change; it returns `false` only when it has positively
confirmed the unit is untouched, and throws on an undeclared unit name so a typo never silently skips. This is the squash-proof, rename-
correct heart of the design — two real commits that exist server-side after the merge, never a hash frozen on a branch.

### Per-layer independence

A layer is a set of peers that partition one concern into boundaries: the `track` layer partitions the tree at the root, the `module` layer
partitions module-space, the `deployable-unit` layer partitions what ships. Overlap between peers means one boundary consumes another's
files. So within a layer the sets are pairwise-disjoint — but on their **OWN** contribution, never their effective membership
(`ADR-FLOW-CD-GLOBS:10`). The distinction is what makes `compose` legal: a customer deployable-unit's _effective_ members include the whole
base it composes, so on effective membership every customer overlaps the base and each other through it. That overlap is the point of
composition — "depends on a base" — not a peer collision. On OWN membership (compose ignored) the customer units own only their own
`configuration/<key>/**` slice and the base owns the shared surface minus the config folders, so the layer is disjoint. The same holds
across layers by design: a file under `automation/Catzc.Base.Globs/` belongs to the `automation` track AND the `catzc-base-globs` module AND
(if it ships) a deployable-unit — three boundaries in three layers, one file. Cross-layer overlap is never a violation; only same-layer
overlap is.

Catch-alls keep a layer total without breaking disjointness. The `repository` track owns every root file `automation`/`infrastructure` do
not — the complement — so it can never overlap them; add a track and its files leave `repository` automatically, but only if the new track
is also excluded there, which the gate checks. The `module-leftovers` set is the module-space complement: it should be empty in a clean
tree, a tripwire for a file dropped at `automation/`'s root or a folder not yet a module. The `loose-fileset` layer is exempt because its
sets are defined to cut across the boundaries. The gate evaluates OWN membership over the tracked-file universe for the declared registry
and the derived module sets together, so a mis-scoped module include, a track that reaches into another's files, or an umbrella mistakenly
declared a `module` fails as a named pair.

### How this is enforced

- `GlobsConfig` validates the schema and every pattern at config load, rejecting unknown keys, malformed patterns (`ADR-FLOW-CD-GLOBS:3`),
  and cyclic or self-referential compose (`ADR-FLOW-CD-GLOBS:8`).
- `Test-AdoPipelineTriggerGlob` and `Test-GitHubWorkflowTriggerGlob` recompute each pipeline-bound globset's native projection and compare
  it to what the bound pipeline/workflow actually declares; integrity-tagged tests assert every trigger is a `Match`, so a hand-edited or
  drifted `paths:` filter fails `Test-Automation` locally and in CI.
- The coverage integrity test confirms every member of a pipeline-bound set is covered by an ADO include pattern — an include-only
  projection is a safe superset that can never under-trigger, with `Test-GlobSetAffected` supplying exactness on top.
- Grep-ability: `paths:` filters in `pipelines/*.yaml` and `.github/workflows/` are generated from `globs.yml`; a filter that disagrees with
  the projection is findable by the drift gate and wrong by rule (`ADR-FLOW-CD-GLOBS:6`).

## Consequences

- One edit point: recomposing a deployable unit touches `globs.yml`, and the projected triggers regenerate from it — never N pipelines by
  hand in two vendor dialects.
- No false-red mainline: because nothing per-set is committed and gated, a busy mainline cannot go red from a stale, forgotten, or
  concurrently-merged marker — the failure mode the committed-hash design carried.
- No-start where it can be: modern ADO and GitHub filter on the projected patterns directly, so a pipeline whose unit is untouched does not
  start at all; the in-pipeline `Test-GlobSetAffected` gate is the exact backstop for the residue.
- Reviewable deploys: "this change touches unit X" is the computed area-of-control report over the PR diff — derived, so it can never go
  stale, and correct across renames.
- Contributors carry no marker-regeneration duty; the drift gate keeps the generated triggers honest, and the identity used for protection
  is live, per session.

## Related

- [pipeline-types](pipeline-types.md) — the per-kind trigger contracts that register on the native projection.
- [tracks](../design/tracks.md) — the root concerns whose subscription surface the globsets are.
- [protected-globs](../automation/protected-globs.md) — the session-memory protection map the live durable SHA keys.
- [pipeline-detection](pipeline-detection.md) — the execution-context detection the reference-commit resolver builds on.
- [native-csharp-types](../automation/BCL/native-csharp-types.md) — the host-guaranteed type set the dialect implementation draws on.
- [everything-as-code](../principles/everything-as-code.md), [poka-yoke](../principles/poka-yoke.md),
  [reduce-variability](../principles/reduce-variability.md) — the principles this mechanism instantiates.

## Dora explains

DORA's research links version-controlled configuration and deterministic deployment triggering to faster, more reliable deployments. Keeping
area-of-control boundaries as one declarative source of truth — projected into native trigger filters and reflected from git history rather
than frozen into committed per-set hashes — reduces deployment drift, keeps the mainline continuously integrable (no false-red from a stale
marker), and makes CI trigger points reviewable as a first-class concern.

- [Version control](https://dora.dev/capabilities/version-control/) — area-of-control boundaries as one committed source of truth, the
  single configuration point.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — squash-safe, rename-correct triggering that never
  false-reds the mainline.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — one unit change is one `globs.yml` edit, its area of
  control computed, not argued.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
