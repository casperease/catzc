# Catzc.Base.Globs

The globset primitive: the single source of truth (`globs.yml`) mapping every deployable unit onto its files under version control, the
durable SHA that is the unit's identity, the committed trigger files pipelines and workflows register on, and the session-memory protection
that skips a repeated local scan over an unchanged set. The governing decisions are
[durable-sha-globs](../../adr/pipelines/durable-sha-globs.md) and [protected-globs](../../adr/automation/protected-globs.md); the module
owns the glob dialect, the hash recipe, and all reading and writing of `.triggers/` — pipelines carry registrations only, never source-path
filters.

## Domains

| Domain   | Area       | Name                                                                         |
| -------- | ---------- | ---------------------------------------------------------------------------- |
| domain:1 | registry   | [The globset registry](#domain1--the-globset-registry)                       |
| domain:2 | identity   | [Membership and durable identity](#domain2--membership-and-durable-identity) |
| domain:3 | triggers   | [Trigger files](#domain3--trigger-files)                                     |
| domain:4 | protection | [Protected scans](#domain4--protected-scans)                                 |

### domain:1 — The globset registry

Owning `configs/globs.yml` and its typed, strictly validated read: each globset is a kebab-case name, a description, include patterns, and
optional exclude patterns, compiled at load into `[Catzc.Base.Globs.GlobSet]` records (per-segment PowerShell wildcards, `**` as the only
cross-segment operator, case-sensitive). Validation rejects unknown keys, malformed patterns, and any set that would have a trigger file as
a member.

### domain:2 — Membership and durable identity

Resolving a globset to its actual members — the tracked-file universe (`git ls-files`) intersected with the set's membership, ordinally
sorted — and computing the durable SHA over them: per file, SHA-256 of the CR-stripped bytes; folded as `<path>|<digest>` lines; one
combined SHA-256. The identity is EOL-insensitive, rename-sensitive, and equal to the committed trigger identity whenever the working tree
is clean in scope.

### domain:3 — Trigger files

Writing and verifying `.triggers/<name>.sha256` — one 64-hex line plus LF per globset, written only when changed, orphans removed. The
freshness query reports Fresh/Stale/Missing/Orphaned per set; the module's integrity test asserts all-Fresh, which is what makes the "commit
the trigger file with the change" discipline self-enforcing.

### domain:4 — Protected scans

The session-memory skip for heavy read-only scans: a (test, globset) key holds the durable SHA of the last green run; an unchanged set
answers "protected" and the scan is skipped. Recording happens only after a green run, on the hash computed before the scan, and in a
pipeline the whole mechanism is ignored — CI always scans full.

## What the module does

One configuration point defines what each deployable unit _is_; everything else derives. Because the identity is a pure function of tracked
bytes, the same recipe serves two consumers with different lifetimes: committed trigger files (the cross-machine, cross-run identity that
ADO and GitHub path filters register on) and the in-session protection map (the this-session-only identity that spares the local inner loop
repeated proof). Neither consumer parses vendor glob dialects — matching happens here, in one dialect, against `git ls-files`.

The module sits in the Base cluster and stays primitive: it knows nothing about pipelines, Pester, or the scans it protects.
`Catzc.Base.QualityGates` consumes it from above (the trigger-freshness and protected integrity tests); the pipeline YAML consumes it from
outside (registrations on `.triggers/` paths).

## Division

The module's public surface, indexed by domain.

| Domain                                     | Function                  |
| ------------------------------------------ | ------------------------- |
| domain:1 — The globset registry            | `Get-GlobSet`             |
| config                                     | `globs.yml`               |
| domain:2 — Membership and durable identity | `Get-GlobSetFile`         |
|                                            | `Get-GlobSetHash`         |
| domain:3 — Trigger files                   | `Update-Trigger`          |
|                                            | `Test-Trigger`            |
| domain:4 — Protected scans                 | `Test-GlobSetProtection`  |
|                                            | `Protect-GlobSet`         |
|                                            | `Clear-GlobSetProtection` |
