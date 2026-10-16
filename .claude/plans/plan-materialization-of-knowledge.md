---
plan:
  status: blocked
  value: medium
  reviewed: 2026-10-16
  blocked_on: three choices to confirm before the ADR is written
  targets: [docs/adr/automation, automation/Catzc.Base.Docs/configs/glossary.yml, automation/Catzc.Base.Docs/configs/adrs.yml]
---

# Materialization: when a knowledge resource comes into being and how long it holds

A draft, not yet an ADR (suggested code ADR-AUTO-MATERIAL, next to ADR-AUTO-CACHE). Most information in cats exists only when asked
for: a scan, a derived listing, a resolved config. Some can be frozen at commit and never change. Materialization names that axis so a
reader knows whether a resource is probably warm or has to be made cold.

## Why its value is medium

It is doctrine that several plans lean on without naming it: the sha-marker companion, the lazy types load, the analyzer cache, the
generated heads. One word and one default prevent each of them from inventing its own cache story. No plan is blocked on it today.

## The axis, as drafted

- on-demand: made when asked, holds until the call ends or the session cache entry; cold, a tool may have cached it.
- commit: made at commit, keyed by the scoped sha of its inputs; never changes, the key is its identity; warm, invalidation is free.
- default: resolved from context into one of the two, never a stored or displayed value (same shape as ADR-AUTO-DEFAULT#6 and the
  assert-guard idea). Clean tree at a known sha with a commit copy present uses the copy; dirty tree or no copy computes on-demand and
  says so; a millisecond-cheap resource never earns a commit copy.
- Fit: ADR-AUTO-CACHE#5, #6, #9; ADR-PRIN-ONELIVE (one version per key); mono repo (scoped sha, not whole-repo sha); guards are controls
  (a guard is pinned on-demand, the default never picks commit for it); configure, don't program (per kind, in a config entry).
- The word won over existence, residency and persistence (persistence is taken by the sha-marker plan's opt-out). It is the database term.

## Needed docs

- ADR-AUTO-MATERIAL: the axis, the default, the guard exception, the loud fallback. Registered in adrs.yml and the index table.
- Glossary entry in the owning module's configs/glossary.yml, contrasting cache and persistence.
- The sha-marker companion plan rewritten to say its marker is a commit-materialized resource.

## Needed tests

- Test-AdrRegistry, Test-Glossary, Test-Links clean after the ADR lands.
- When a resolver exists: dirty tree falls back loudly (one announced line); a guard kind never resolves to commit.

## Open steps

- [ ] Confirm the three choices: scoped-sha commit key; declared per resource kind with one default, instances pin only explicitly;
  dirty tree falls back to on-demand loudly (check: the draft's Open choices section says confirmed).
- [ ] Write the ADR and the glossary entry (check: the three gates clean).
- [ ] Check the sha-marker companion plan for overlap (check: its text names materialization).

## Refs

- the ADR draft is carried below in full (formerly out/adr-draft-materialization.md)
- docs/adr/automation/result-caching.md (ADR-AUTO-CACHE, path to verify)
- memory: materialization-of-knowledge-resources.md, sha-marker-companion-and-pipeline-types.md

## Carried: out/adr-draft-materialization.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Draft: materialization of knowledge resources

Status: draft for review, not yet an ADR. Promote to an ADR next to `ADR-AUTO-CACHE` (suggested code `ADR-AUTO-MATERIAL`) after the three
open choices at the bottom are confirmed. The glossary term and the registry entry follow with it.

## The idea

Most information in catzc exists only when someone asks for it: a repo scan, a derived listing, a resolved config. Tools cache some of it.
Some information can instead be frozen with a commit and never change. **Materialization** names when a knowledge resource comes into
being and how long it holds. It tells a reader whether the resource is probably already there (warm) or has to be made (cold).

The word was chosen over "existence" (it says _whether_, not _when and how long_), "residency" (suggests location, not time), and
"persistence" (already used by the sha-marker plan for its opt-out). It is the database term: a plain view is computed per query, a
materialized view is stored.

## The axis

Two real values and a default that resolves to one of them.

| value         | comes into being                                       | holds until                                 | cache expectation                         |
| ------------- | ------------------------------------------------------ | ------------------------------------------- | ----------------------------------------- |
| **on-demand** | when asked (a scan, a computation)                     | the call ends, or the session cache entry   | cold; a tool may have cached it           |
| **commit**    | at commit, keyed by the scoped sha of its inputs       | never changes: the key is its identity      | warm; invalidation is free                |
| _(default)_   | resolved from context into on-demand or commit         | n/a                                         | n/a                                       |

`auto` is not a third peer. It means "not pinned, so resolve", the same shape as the one resolution order (`ADR-AUTO-DEFAULT#6`) and the
assert-guard idea (determine from ambient context, pin with an explicit override). It is never a stored value. Displays hide it for the
same reason they hide any default: only a pinned value is shown.

## How the default resolves

- A clean tree at a known scoped sha, with a commit copy present: use the commit copy.
- A dirty tree, or no copy: compute on-demand, and say so (see the open choices).
- A resource that is cheap to compute (milliseconds) never earns a commit copy.

## Fit with existing rules

- `ADR-AUTO-CACHE#6` and `#9`: the importer is the only invalidation, and git state that changes inside a session is keyed on its own
  content. The commit value is that same idea made durable: the key is the content, so nothing ever invalidates it.
- `ADR-AUTO-CACHE#5`: a materialized value is read-only to callers.
- `ADR-PRIN-ONELIVE`: one version of each resource per key; no parallel on-demand and commit shapes of the same data.
- Mono repo, not monolith: the commit key is the scoped sha of the resource's own inputs, so an unrelated commit does not invalidate it.
- Guards are controls (devbox is also a regulated opsbox): a guard's verdict is never cached across a session. Materialization is therefore
  partly a property of the resource kind: a guard is pinned on-demand and the default must never pick commit for it.
- Configure, don't program: the materialization of a kind is a config entry with its default declared once, not per-call code.

## Open choices (recommendations taken, confirm before the ADR)

1. **Commit key:** the scoped sha of the resource's inputs, not the whole-repo commit sha.
2. **Where declared:** per resource kind in a config entry with one default; instances do not override it, except through an explicit pin.
3. **Dirty tree:** a commit-materialized resource falls back to on-demand loudly (one announced line), never silently.

## Next steps

- Confirm the three choices, then write the ADR (rules for the axis, the default, the guard exception, the loud fallback).
- Add the glossary entry in the owning module's `configs/glossary.yml` (never the generated page), contrasting with "cache" and "persistence".
- Check the sha-marker companion plan for overlap: its marker is a commit-materialized resource.
