# Catzc.Base.Globs

The globset primitive: the single source of truth (`globs.yml`) mapping every deployable unit onto its files under version control, the
native path-filter projection that pipelines and workflows trigger on, the git-reflected "which areas of control did this change touch"
report, and the session-memory protection that skips a repeated local scan over an unchanged set. The governing decisions are
[durable-sha-globs](../../adr/pipelines/durable-sha-globs.md) and [protected-globs](../../adr/automation/protected-globs.md); the module
owns the glob dialect, the durable-SHA identity, the vendor projection, and the git-reflection query — pipelines carry generated
registrations only, never hand-authored source-path filters, and nothing is committed per set.

## Domains

| Domain   | Area       | Name                                                                               |
| -------- | ---------- | ---------------------------------------------------------------------------------- |
| domain:1 | registry   | [The globset registry](#domain1--the-globset-registry)                             |
| domain:2 | identity   | [Membership and durable identity](#domain2--membership-and-durable-identity)       |
| domain:3 | triggers   | [Native triggers and git reflection](#domain3--native-triggers-and-git-reflection) |
| domain:4 | protection | [Protected scans](#domain4--protected-scans)                                       |

### domain:1 — The globset registry

Owning `configs/globs.yml` and its typed, strictly validated read: each globset is a kebab-case name, a description, a layer, include
patterns, and optional exclude patterns, compiled at load into `[Catzc.Base.Globs.GlobSet]` records (per-segment PowerShell wildcards, `**`
as the only cross-segment operator, case-sensitive). A layer is the kind of boundary the set maps: `track` (a root-level partition, e.g.
`automation`/`infrastructure`, with the `repository` catch-all for everything else at root), `deployable-unit` (a configurable unit that
ships), or `loose-fileset` (a cross-cutting scan scope or reserved umbrella); `module` (per-folder, with the `module-leftovers` catch-all)
is derived from the folders and never declared. Validation rejects unknown keys, malformed patterns, and cyclic or self-referential compose.
Within every layer but `loose-fileset` no two sets may overlap on their OWN contribution — a boundary never consumes a peer's files
(`ADR-GLOBS:10`); loose-filesets overlap the boundaries they cut across by design.

### domain:2 — Membership and durable identity

Resolving a globset to its actual members — the tracked-file universe (`git ls-files`) intersected with the set's membership, ordinally
sorted — and computing the durable SHA over them: per file, SHA-256 of the CR-stripped bytes; folded as `<path>|<digest>` lines; one
combined SHA-256. The identity is EOL-insensitive and rename-sensitive, computed live and never committed: it is the cross-machine identity
the session-memory protection map keys on (domain:4), not a trigger and not a committed artifact.

### domain:3 — Native triggers and git reflection

The two derivations that replace a committed per-set marker. The **projection** renders a globset's flattened scan program into each
vendor's native path-filter dialect — GitHub `on.*.paths` with ordered `!` negation (exact), Azure DevOps `trigger.paths.include`/`exclude`
and branch-policy `filenamePatterns` (order-independent, last-select-per-pattern) — so a pipeline triggers, or does not start at all, on the
real files; a drift gate compares each pipeline's declared trigger to the projection and fails a mismatch. The **git reflection** answers
"did this change touch the unit?" from git at the real refs: it diffs a commit range (resolving the reference commit per context —
post-commit first-parent `HEAD^1..HEAD`, PR merge-base, or local working tree) and matches the changed paths against the registry, the same
computation the in-pipeline "stop, nothing here for us" gate and the PR area-of-control report use. Because it reads the merged tree as it
actually is, it is immune to squash-merge and concurrent-merge staleness and correct across renames.

### domain:4 — Protected scans

The session-memory skip for heavy read-only scans: a (test, scope) key holds the durable identity of the last green run; an unchanged scope
answers "protected" and the scan is skipped. Recording happens only after a green run, on the identity computed before the scan, and in a
pipeline the whole mechanism is ignored — CI always scans full. Every globset — the **declared** registry (domain:1) and the **derived**
sets the registry never lists (one per module folder by convention, one per internal `.psm1` module, the reserved infra umbrellas
`internal`/`vendor`/`compiled`/`scriptanalyzer`, and the `module-leftovers` catch-all) — scopes protection and blast-radius through the same
`Matches()` machinery, with nothing committed per set. The derived sets double as the building blocks `Test-Automation` composes into
per-module protection identities.

## What the module does

One configuration point defines what each deployable unit _is_; everything else derives. Because the identity and membership are pure
functions of tracked bytes, the module serves three consumers from one dialect: the native projection ADO and GitHub path filters trigger on
(generated, drift-checked), the git-reflected area-of-control the PR report and the in-pipeline gate read, and the in-session protection map
that spares the local inner loop repeated proof. None of them parses vendor glob dialects — matching happens here, once, against
`git ls-files` — and none commits a per-set artifact, so a busy mainline never goes red from a stale marker.

The module sits in the Base cluster and stays primitive: it knows nothing about pipelines, Pester, or the scans it protects.
`Catzc.Base.QualityGates` consumes it from above (the trigger-drift and protected integrity tests); the pipeline YAML consumes its
projection from outside (generated `paths:` registrations).

## Division

The module's public surface, indexed by domain.

| Domain                                        | Function                         |
| --------------------------------------------- | -------------------------------- |
| domain:1 — The globset registry               | `Get-GlobSet`                    |
|                                               | `Test-GlobSetIndependence`       |
| config                                        | `globs.yml`                      |
| domain:2 — Membership and durable identity    | `Get-GlobSetFile`                |
|                                               | `Get-GlobSetHash`                |
| domain:3 — Native triggers and git reflection | `Get-GlobSetTrigger`             |
|                                               | `Test-AdoPipelineTriggerGlob`    |
|                                               | `Test-GitHubWorkflowTriggerGlob` |
|                                               | `Get-ChangedGlobSet`             |
|                                               | `Get-GlobSetChangeRange`         |
|                                               | `Test-GlobSetAffected`           |
|                                               | `Get-MarkerBlastRadius`          |
| domain:4 — Protected scans                    | `Test-GlobSetProtection`         |
|                                               | `Protect-GlobSet`                |
|                                               | `Clear-GlobSetProtection`        |
|                                               | `Get-ModuleGlobSet`              |
