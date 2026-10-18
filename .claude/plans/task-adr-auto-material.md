---
task:
  status: open
  plans: [plan-materialization-of-knowledge]
  value: medium
  blocked_on: nothing; D16 confirmed 2026-10-18
  targets: [docs/adr/automation, automation/Catzc.Base.Docs/configs/adrs.yml, automation/Catzc.Base.Docs/configs/glossary.yml]
---

# Task: ADR-AUTO-MATERIAL

Decided (Q66 to Q70, F7, S4): materialization is the axis on-demand or commit with a default resolved from context, never stored; the commit
key is the scoped sha of a deployable-module globset (globs.yml patterns, config variants possible); declared per resource kind with one
default, an instance changes it only by an explicit pin; a commit resource on a dirty tree falls back to on-demand with one announced line;
generated tracked files and the analyzer cache are commit resources keyed by their globset, body_sha the key's visible form; a guard is
pinned on-demand. The draft is carried in the plan; it becomes the ADR in present tense.

## Steps

1. [x] `docs/adr/automation/materialization.md`, new, next to result-caching.md,
       `# ADR-AUTO-MATERIAL: materialization of knowledge resources`. Rules: 1 **materialization** names when a resource comes into being
       and how long it holds, on-demand or commit; 2 the default resolves from context and is never stored or displayed; 3 the commit key is
       the scoped sha of the resource's globset; 4 declared per resource kind in a config entry with one default, pinned per instance only
       explicitly; 5 a commit resource on a dirty tree or without a copy computes on-demand and announces it once; 6 a guard is pinned
       on-demand, never commit; 7 generated tracked files and the analyzer cache are commit resources and body_sha is the key's visible
       form. Context from the carried draft (fit with ADR-AUTO-CACHE#5, #6, #9; ADR-PRIN-ONELIVE; the word chosen over existence, residency,
       persistence, stated as the present reason). Check: Test-Markdownlint, Test-Links clean; Format-FileMeta writes
       `defines: ADR-AUTO-MATERIAL#{1-7}`. Done 2026-10-18: seven rules with their sections, the fit with ADR-AUTO-CACHE, the enforcement
       list and four alternatives; the head reads `defines: ADR-AUTO-MATERIAL#{1-7}`. Corrections: rule 7 names `body_sha` without citing
       the repository domain, which automation may not cite (Test-AdrRegistry); the ADR says "declared explicitly" where the draft said
       "pinned", since pin is the thesis domain's term for a consumer's version; the persistence sentence names what the word means, not a
       companion plan. `MDLINT issues=0`, `LINKS issues=0` (`out/test-links/20261018-110057`).
2. [x] `adrs.yml` automation rulesets: `materialization: { external: ADR-AUTO-MATERIAL }`. `Build-AdrIndex`. Check: Test-AdrRegistry clean;
       the index lists it. Done 2026-10-18: `materialization: { external: ADR-AUTO-MATERIAL, concern: [quality-control] }`;
       `ADRREG issues=0` (`out/test-adr-registry/20261018-110057`), `NEUTRAL issues=0`, the index lists the code.
3. [x] `docs/adr/automation/dora-explains.md`: one entry (fast feedback: a warm commit resource makes a check cheap; a loud fallback keeps
       it honest). Check: Test-Links. Done 2026-10-18: the entry sits before "Tracked files from the index" with three capability links;
       `LINKS issues=0`.
4. [x] `glossary.yml`: `materialization` defined by ADR-AUTO-MATERIAL#1, contrasts cache (a tool's copy inside a session) and persistence
       (the sha-marker opt-out), avoid "cached at commit". `Build-Glossary`. Check: Test-Glossary clean. Done 2026-10-18 in the Docs
       glossary (domain automation). Correction: cache and persistence are not glossary terms and a contrast must be reciprocal, so the
       entry contrasts `meta head`, where a generated file shows its commit key, with the reciprocal line on that term; the avoid list holds
       "cached at commit" and "materialized view". `GLOSSARY issues=0` (`out/test-glossary/20261018-110106`).
5. [x] The sha-marker companion plan (memory note sha-marker-companion-and-pipeline-types.md, no plan file yet): one sentence that its
       marker is a commit-materialized resource, written where the plan lands when it is opened; until then a line in this plan's Decided.
       Check: the line exists. Corrected 2026-10-18 from the tree: no sha-marker exists in the repository (the memory note itself records
       the pivot to native triggers and an in-pipeline git check), so there is no companion to open and nothing names it; the line is in the
       plan's Decided.
6. [x] `plan-materialization-of-knowledge.md`: tick both steps; the carried draft is dropped (its data is in the ADR); the plan is deleted
       in task-closing-sweep. Check: grep `- [ ]` counts zero. Done 2026-10-18: both ticked, the carried draft dropped, the count is zero.

## Report

As report-fixed.
