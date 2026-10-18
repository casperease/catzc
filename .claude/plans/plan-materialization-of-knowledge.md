---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [docs/adr/automation, automation/Catzc.Base.Docs/configs/glossary.yml, automation/Catzc.Base.Docs/configs/adrs.yml]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-materialization-of-knowledge.md"
    folder: plans
    name: plan-materialization-of-knowledge
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-CACHE#5
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-MATERIAL#3
---

# Materialization: when a knowledge resource comes into being and how long it holds

A draft, not yet an ADR (suggested code ADR-AUTO-MATERIAL, next to ADR-AUTO-CACHE). Most information in cats exists only when asked for: a
scan, a derived listing, a resolved config. Some can be frozen at commit and never change. Materialization names that axis so a reader knows
whether a resource is probably warm or has to be made cold.

## Why its value is medium

It is doctrine that several plans lean on without naming it: the sha-marker companion, the lazy types load, the analyzer cache, the
generated heads. One word and one default prevent each of them from inventing its own cache story. No plan is blocked on it today.

## The axis, as drafted

- on-demand: made when asked, holds until the call ends or the session cache entry; cold, a tool may have cached it.
- commit: made at commit, keyed by the scoped sha of its inputs; never changes, the key is its identity; warm, invalidation is free.
- default: resolved from context into one of the two, never a stored or displayed value (same shape as ADR-AUTO-DEFAULT#6 and the
  assert-guard idea). Clean tree at a known sha with a commit copy present uses the copy; dirty tree or no copy computes on-demand and says
  so; a millisecond-cheap resource never earns a commit copy.
- Fit: ADR-AUTO-CACHE#5, #6, #9; ADR-PRIN-ONELIVE (one version per key); mono repo (scoped sha, not whole-repo sha); guards are controls (a
  guard is pinned on-demand, the default never picks commit for it); configure, don't program (per kind, in a config entry).
- The word won over existence, residency and persistence (persistence is taken by the sha-marker plan's opt-out). It is the database term.

## Session report of 2026-10-16 15:35, and why it stayed a draft

- Written as a draft laid out like the earlier adr-draft files, not promoted; no gates or tests run. Held back because a new ADR needs an
  adrs.yml entry, a glossary entry, a dora-explains.md entry and a regenerated index, and because a rule the user has not confirmed is not
  recorded as a rule. The three open choices below are the session's own recommendations, taken for the draft only.
- Memory entry materialization-of-knowledge-resources.md saved with its MEMORY.md pointer.

## Decided in the questionnaire round of 2026-10-16 (Q66 to Q70, F7, S4)

- The commit key is the scoped sha of a deployable-module globset (the patterns in globs.yml), with config variants possible; the user's
  words: "scoped shas should basically be our deployable module glob patterns we can make config variants for".
- Declared per resource kind with one default; an instance changes it only by an explicit pin. A commit resource on a dirty tree falls back
  to on-demand with one announced line. Its own ADR, ADR-AUTO-MATERIAL, next to ADR-AUTO-CACHE, written now.
- Scope (F7): generated tracked files and the analyzer cache become commit resources keyed by their globset; body_sha is that key's visible
  form; on-demand stays the default for everything else.
- D16 (2026-10-18): the three choices stand, nothing reopens; task-adr-auto-material writes ADR-AUTO-MATERIAL as drafted.
- A sha marker, if one is ever opened, is a commit resource keyed by its globset (ADR-AUTO-MATERIAL#3); the repository holds none.

## Needed docs

- ADR-AUTO-MATERIAL: the axis, the default, the globset key, the guard exception, the loud fallback, the kinds that are commit resources.
  Registered in adrs.yml, a dora-explains.md entry, the index regenerated.
- Glossary entry in the owning module's configs/glossary.yml, contrasting cache and persistence.
- The sha-marker companion plan rewritten to say its marker is a commit-materialized resource.

## Needed tests

- Test-AdrRegistry, Test-Glossary, Test-Links clean after the ADR lands.
- When a resolver exists: dirty tree falls back loudly (one announced line); a guard kind never resolves to commit.

## Open steps

- [x] Write the ADR and the glossary entry from the decided section (check: the three gates clean). Done 2026-10-18
      (task-adr-auto-material): ADR-AUTO-MATERIAL with seven rules, registered, a dora-explains entry, the glossary term; `ADRREG issues=0`,
      `GLOSSARY issues=0`, `LINKS issues=0`.
- [x] Check the sha-marker companion plan for overlap (check: its text names materialization). 2026-10-18: no sha-marker exists in the tree
      and no companion plan is open, so there is no overlap to check; the ADR's persistence sentence names no companion.

## Refs

- docs/adr/automation/materialization.md (ADR-AUTO-MATERIAL)
- docs/adr/automation/caching.md (ADR-AUTO-CACHE)
- memory: materialization-of-knowledge-resources.md, sha-marker-companion-and-pipeline-types.md
