---
task:
  id: "012"
  status: open
  plans: [plan-module-kinds-tracks]
  value: high
  blocked_on: task011 steps 1 to 4 (the model confirmed)
  targets:
    [
      automation/Catzc.Base.Globs/configs/file-kinds.yml,
      automation/Catzc.Base.QualityGates/configs/file-meta.yml,
      automation/Catzc.Base.Variants/types,
      docs/adr/design/tracks.md,
      docs/adr/automation/module-model.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task012.md"
    folder: plans
    name: task012
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task012: kind becomes role; the track rules

Decided (k8s plan, Q27 to Q38, Q98): Track is the root entity and Module one of its kinds; `kind` takes the Kubernetes-style object meaning,
partitioned by track, and what the file-kinds registry calls kind today (readme, config, adr, agent) becomes `role`. The head key `kind` in
every file then means the object kind. A rename touches the registry, the head processors, the contract schema and every head; it runs
through the generators, never by sweep: change the source once, regenerate, verify.

## Steps

1. Read first, no edit: `file-kinds.yml` (the registry), `file-meta.yml` kind `file-kind` (keys `kind, subkind`), `head.schema.json` and
   `head.sample.yml` in `contracts/catzc/0.0.0`, `languages.yml` `layout:` rows (`role:` is already the word there). List every consumer of
   the key `kind` (`grep -rn "\.kind\b\|\['kind'\]\|kind:" automation --include=*.ps1 --include=*.cs` counted per file) in
   `plan-module-kinds-tracks.md` under a "Rename map" heading. Check: the map exists with counts.
2. `automation/Catzc.Base.Variants/types` or wherever `FileKind` lives: the type gains `Role`; `Kind` is reserved for the object kind
   resolved from the track (module, pipeline, settings, vendor, docs). Tests updated. Fresh pwsh. Check: the type's Pester file passes.
3. `file-meta.yml`: kind `file-kind` becomes `file-role` with `keys: [role, subkind]`; a new kind `object-kind` with `keys: [kind]` reads
   the track's kind. Processor added and counted (18 kinds, 19 processors). Check: `Test-FileMetaProcessors` and the two processor tests
   pass.
4. `contracts/catzc/0.0.0` `head.schema.json` and `head.sample.yml`: `role` added, `kind` redefined (hand-written, Q39). Check:
   `Format-FileMeta.Contract.Tests` passes.
5. `Format-FileMeta` over the tree in the background (360 s cap): every head gains `role` and its `kind` changes meaning. Read the diff
   stat. Check: Test-FileMeta clean; Test-GeneratedFiles clean.
6. Docs: `docs/adr/repository/file-meta.md` rules that name the kind key (11 and 12 among them) say role; `docs/adr/design/tracks.md` gains
   rule 19: a track has one primary language by default, declared in the tracks registry, and a module in it may override (Q35);
   ADR-AUTO-MODULE text may now say kind (D02 lifts the hold). Glossary: `role` defined by the file-meta rule, `kind` by the tracks rule;
   the file-kinds entries' `kind` and `subkind` concepts re-pointed. Check: Test-AdrRegistry, Test-Links, Test-Glossary clean.
7. `Test-Links` on `automation/Catzc.Base.Docs/types/WorldMapBuilder.cs` (or its current path). Check: zero findings.
8. `Test-ShippedTypes` in a fresh process: `TrackTypeEntry` and `VendorEntry` resolve after import, or the reason is fixed in the type
   (Q88). Check: the gate is clean on Catzc.Base.Variants.
9. Namespace follow-up (Q36): one Decided line in the plan stating what the namespace of a module is once kinds land (recommendation: the
   track name, so `Catzc.Base.*` stays for the pwsh track) and whether a step follows. Check: the line exists.
10. Tick the plan's five open steps. Check: grep `- [ ]` in `plan-module-kinds-tracks.md` counts zero; the plan then holds only its carried
    drafts and is trimmed by plan-clear (Q11: carried text goes when its data is in the tree).

## Report

As report-fixed, with the diff stat of step 5.
