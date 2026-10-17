---
task:
  id: "026"
  status: open
  plans: [plan-materialization-of-knowledge]
  value: medium
  blocked_on: D16 (a confirmation that nothing reopens)
  targets: [docs/adr/automation, automation/Catzc.Base.Docs/configs/adrs.yml, automation/Catzc.Base.Docs/configs/glossary.yml]
catzc:
  immutable:
    with_body_sha: "9bb2d8a11a28"
    repo_status: clean
    path: ".claude/plans/task026.md"
    folder: plans
    name: task026
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
---

# task026: ADR-AUTO-MATERIAL

Decided (Q66 to Q70, F7, S4): materialization is the axis on-demand or commit with a default resolved from context, never stored; the commit
key is the scoped sha of a deployable-module globset (globs.yml patterns, config variants possible); declared per resource kind with one
default, an instance changes it only by an explicit pin; a commit resource on a dirty tree falls back to on-demand with one announced line;
generated tracked files and the analyzer cache are commit resources keyed by their globset, body_sha the key's visible form; a guard is
pinned on-demand. The draft is carried in the plan; it becomes the ADR in present tense.

## Steps

1. `docs/adr/automation/materialization.md`, new, next to result-caching.md, `# ADR-AUTO-MATERIAL: materialization of knowledge resources`.
   Rules: 1 **materialization** names when a resource comes into being and how long it holds, on-demand or commit; 2 the default resolves
   from context and is never stored or displayed; 3 the commit key is the scoped sha of the resource's globset; 4 declared per resource kind
   in a config entry with one default, pinned per instance only explicitly; 5 a commit resource on a dirty tree or without a copy computes
   on-demand and announces it once; 6 a guard is pinned on-demand, never commit; 7 generated tracked files and the analyzer cache are commit
   resources and body_sha is the key's visible form. Context from the carried draft (fit with ADR-AUTO-CACHE#5, #6, #9; ADR-PRIN-ONELIVE;
   the word chosen over existence, residency, persistence, stated as the present reason). Check: Test-Markdownlint, Test-Links clean;
   Format-FileMeta writes `defines: ADR-AUTO-MATERIAL#{1-7}`.
2. `adrs.yml` automation rulesets: `materialization: { external: ADR-AUTO-MATERIAL }`. `Build-AdrIndex`. Check: Test-AdrRegistry clean; the
   index lists it.
3. `docs/adr/automation/dora-explains.md`: one entry (fast feedback: a warm commit resource makes a check cheap; a loud fallback keeps it
   honest). Check: Test-Links.
4. `glossary.yml`: `materialization` defined by ADR-AUTO-MATERIAL#1, contrasts cache (a tool's copy inside a session) and persistence (the
   sha-marker opt-out), avoid "cached at commit". `Build-Glossary`. Check: Test-Glossary clean.
5. The sha-marker companion plan (memory note sha-marker-companion-and-pipeline-types.md, no plan file yet): one sentence that its marker is
   a commit-materialized resource, written where the plan lands when it is opened; until then a line in this plan's Decided. Check: the line
   exists.
6. `plan-materialization-of-knowledge.md`: tick both steps; the carried draft is dropped (its data is in the ADR); the plan is deleted in
   T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
