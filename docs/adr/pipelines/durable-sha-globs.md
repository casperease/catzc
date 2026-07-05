# ADR: Durable-SHA globs — deployable-unit triggers as version-controlled state

## Rules: ADR-GLOBS

### Rule ADR-GLOBS:1

One source of truth: named globsets in `globs.yml` (owned by `Catzc.Base.Globs`) map each deployable unit onto its files under version
control. Pipelines, workflows, and build-validation policies path-filter only on the unit's trigger file `triggers/<name>.sha256`, never on
source paths.

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
`<repo-relative-path>|<digest>` lines, ordinal-sorted by path, into one combined SHA-256. The trigger file contains exactly the lowercase
hex digest and a trailing LF, nothing else.

- [The durable SHA](#the-durable-sha)

### Rule ADR-GLOBS:6

A commit that changes any file a globset matches also carries that globset's regenerated trigger file. A stale, missing, or orphaned trigger
file fails the integrity gate. No globset may match `triggers/` or `globs.yml` itself: trigger files are outputs of the hash, never inputs.

- [Commit discipline](#commit-discipline)
- [How this is enforced](#how-this-is-enforced)

## Context

A deployable unit is a high-level composition of modules in the modular repository, mapped onto actual files under version control. Both
Azure DevOps (`trigger:`/`pr:` `paths:`, build-validation policies) and GitHub (`on.*.paths`) decide whether to run by matching changed
paths against filter lists. Writing those lists directly into every pipeline and workflow scatters one fact — "which files compose this
unit" — across the orchestration layer, in two vendor dialects with subtly different wildcard semantics, where drift is invisible until a
deploy silently does not fire.

The durable-SHA design inverts this: the composition is declared once, at the deterministic source-of-truth layer, and each unit's identity
is materialized as a committed hash. Orchestration artifacts hold a registration — a single-path filter on the trigger file — and nothing
else.

## Decision

### One configuration point

`globs.yml` holds every globset: a kebab-case name, a description, an `include:` pattern list, and an optional `exclude:` pattern list.
`Catzc.Base.Globs` owns the file, the dialect, the hash, and all reading and writing of `triggers/`; nothing else parses the config or
writes into that folder. A pipeline or workflow references a unit by registering the unit's trigger-file path as its only path filter, so
adding or removing files from a unit is a config edit, never an orchestration edit.

### The dialect

Vendor path-filter dialects are irrelevant here: matching happens in our own code against the tracked-file list, and the vendors only ever
see the trigger-file path. That frees the dialect to be the one this repository's users already know — within a segment, a pattern means
exactly what it means to PowerShell's `-like` operator, delegated to `System.Management.Automation.WildcardPattern` (a host-guaranteed type;
see [native-csharp-types](../automation/BCL/native-csharp-types.md)). Matching is case-sensitive because tracked paths are case-sensitive
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

The trigger file is minimal on purpose: one hex line, LF, no header. A one-line diff is the whole review surface, and `.gitattributes` pins
the line ending.

### Commit discipline

Vendor triggers fire on changed paths in a push. The trigger file is what turns "this unit changed" into a changed path: whoever changes a
member file regenerates the trigger file (`Update-Trigger`) and commits both together. The integrity gate makes the discipline
self-enforcing — a stale trigger file fails CI, so the only way to land a unit change is to also land its new identity. The self-exclusion
rule keeps regeneration stable: writing a trigger file never changes any globset's input, so one pass always converges.

### How this is enforced

- `GlobsConfig` validates the schema and every pattern at config load, rejecting unknown keys, malformed patterns (`ADR-GLOBS:3`), and
  self-matching globsets (`ADR-GLOBS:6`).
- `Test-Trigger` recomputes every globset's durable SHA and reports stale, missing, and orphaned trigger files; an integrity-tagged test in
  `Catzc.Base.Globs` asserts it, so `Test-Automation` fails locally and in CI on any violation.
- Grep-ability: `paths:` filters in `pipelines/*.yaml` and `.github/workflows/` reference only `triggers/` entries; a source path in a
  filter is findable by search and wrong by rule (`ADR-GLOBS:1`).

## Consequences

- One edit point: recomposing a deployable unit touches `globs.yml`, never N pipelines in two vendor dialects.
- Reviewable deploys: "this commit re-deploys unit X" is a visible one-line diff under `triggers/`, not an inference from path filters.
- The identity is reproducible from any checkout: same tracked content, same SHA, on every platform.
- Contributors carry a duty to regenerate trigger files; the gate converts forgetting from a silent non-deploy into a red build.
- Renames and moves re-trigger by construction, which vendor content-blind path filters get right only by accident.

## Related

- [pipeline-types](pipeline-types.md) — the per-kind trigger contracts that register on trigger files
- [ci-discipline-and-promotion-flow](../design/ci-discipline-and-promotion-flow.md) — the deployable unit's role in CD/CDE governance
- [native-csharp-types](../automation/BCL/native-csharp-types.md) — the host-guaranteed type set the dialect implementation draws on
- [everything-as-code](../principles/everything-as-code.md), [poka-yoke](../principles/poka-yoke.md),
  [reduce-variability](../principles/reduce-variability.md) — the principles this mechanism instantiates
