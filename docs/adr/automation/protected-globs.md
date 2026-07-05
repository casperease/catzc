# ADR: Protected globs — session-memory skip of repeated scans over an unchanged globset

## Rules: ADR-PROTGLOB

### Rule ADR-PROTGLOB:1

A heavy, read-only scan whose inputs are a globset may be skipped locally when that scan already ran green against the globset's current
durable SHA in this session. The protection map is session memory only — never a file, never an environment variable; reloading the importer
clears it, and `Clear-GlobSetProtection` clears it without reloading.

- [The protection map](#the-protection-map)

### Rule ADR-PROTGLOB:2

CI is never protected: in a pipeline the map is neither read nor written, and every scan runs full, every time. The gate is purely a local
inner-loop optimization.

- [Why CI never gates](#why-ci-never-gates)

### Rule ADR-PROTGLOB:3

Only read-only scans are protectable. The `Test-*`/`Format-*` verb contract guarantees a scanner never mutates the fileset it scans, so its
result is a pure function of the globset's identity; a mutating `Format-*` is never protected — a mutator would invalidate the identity it
records.

- [The protection map](#the-protection-map)

### Rule ADR-PROTGLOB:4

The protection key is (test, globset), and the recorded identity is the durable SHA computed **before** the scan, promoted only after the
scan passes (`Test-GlobSetProtection` captures it pending; `Protect-GlobSet` promotes it on green). A red scan is never recorded; an edit
that lands mid-scan leaves a stale record and forces the next run to scan.

- [The pending-promote handshake](#the-pending-promote-handshake)

### Rule ADR-PROTGLOB:5

Fail open: no record, an unknown globset, or any identity mismatch means scan. Every skip is logged with the test, the globset, and the
matched short hash, so a run that skipped is never silently indistinguishable from a run that scanned.

- [The protection map](#the-protection-map)

### Rule ADR-PROTGLOB:6

A protected scan's globset includes the scan's own configuration. The identity must cover everything the scan reads — a config edit that
changes the scan's outcome must re-key the set.

- [Scoping a protected scan](#scoping-a-protected-scan)

## Context

The repository-wide integrity scans (spelling, markdown lint) each take seconds to minutes and are pure functions of the files they read. In
the local inner loop, `Test-Automation` runs them on every invocation — most of the time over byte-identical inputs, proving nothing the
previous run did not already prove. The durable-SHA machinery ([durable-sha-globs](../pipelines/durable-sha-globs.md)) already reduces "did
these inputs change" to one hash comparison, so a repeated identical scan is pure waste ([reduce-waste](../principles/reduce-waste.md)).

## Decision

### The protection map

`Catzc.Base.Globs` keeps a session-memory map keyed `<test>|<globset>`, holding the durable SHA of that scan's last green run.
`Test-GlobSetProtection` answers "may this scan be skipped?" by comparing the globset's current durable SHA against the record; a Pester
integrity test uses the answer to `Set-ItResult -Skipped` instead of scanning. Memory-only is deliberate: a persisted stamp would survive
importer reloads, tool upgrades, and session boundaries the map cannot see; a map that dies with the session can only ever skip what this
session proved green.

Because `Get-GlobSetHash` hashes the working tree's tracked bytes, an uncommitted in-scope edit re-keys the set and defeats protection —
skips happen only for states that byte-equal a state this session scanned green.

### The pending-promote handshake

The identity recorded is always the one computed **before** the scan: `Test-GlobSetProtection` stores the just-computed hash as pending for
its key when it answers "not protected", and `Protect-GlobSet`, called only after the scan passes, promotes exactly that pending value. A
scan that fails never reaches the promote call, so a red result is never cached away; an edit landing mid-scan changes the tree away from
the recorded pre-scan identity, so the next query re-scans. Keep this property named — hashing at promote time would silently protect a
state the scan never read.

### Why CI never gates

CI's job is proof, and the map's guarantee ("this session already proved it") is worthless across machines and runs. In a pipeline
(`Test-IsRunningInPipeline`), `Test-GlobSetProtection` answers `$false` unconditionally and `Protect-GlobSet` is a no-op — the
untracked-file blind spot (a never-added file is outside `git ls-files` and cannot re-key a set) and any session-memory staleness are
therefore bounded by the next CI run, which always scans everything.

### Scoping a protected scan

The globset must cover everything the scan reads — the scanned files **and** the scan's own configuration, since both change the outcome.
The markdown scan protects against `markdown-scope` (in-scope markdown plus the markdownlint config, mirroring the scan's own negation
globs); the spelling scan reads nearly the whole tree including its vocabulary registry, so it protects against the repository-wide
`automation` set. Two scans may share one globset — the key is (test, globset), so one scan's green never skips another.

### How this is enforced

- `Test-GlobSetProtection` / `Protect-GlobSet` / `Clear-GlobSetProtection` in `Catzc.Base.Globs` are the whole surface; the map is private
  module state, so nothing else can read or write protection.
- The pipeline short-circuit is inside the functions themselves (`Test-IsRunningInPipeline`), not at call sites — a caller cannot forget it.
- Grep-ability: every protected scan is findable by `Test-GlobSetProtection`; a scan wrapped without a matching `Protect-GlobSet` simply
  never skips (fail open).

## Consequences

- The local inner loop stops re-paying for unchanged proof: repeat gate runs skip the heavy scans until an in-scope file (or scan config)
  actually changes.
- Skips are trustworthy by construction: working-tree identity, record-only-on-green, pre-scan hashing, and fail-open leave no path to a
  false green — the worst failure mode is a redundant scan.
- CI semantics are untouched: every pipeline run proves the full set, so protection can never hide a violation from the merge gate.
- The map's lifetime is the session's — the cost is a full first scan per session, which is exactly the run that establishes the proof.

## Related

- [durable-sha-globs](../pipelines/durable-sha-globs.md) — the globsets and durable SHA this gate keys on.
- [test-automation](test-automation.md) — the tier/category system the protected integrity scans run under.
- [caching](caching.md) — the general caching rules; this map is deliberately narrower (session memory, never persisted).
- [reduce-waste](../principles/reduce-waste.md), [poka-yoke](../principles/poka-yoke.md) — the principles the gate instantiates.
