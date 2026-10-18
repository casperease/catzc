---
task:
  status: open
  plans: [plan-module-kinds-tracks]
  value: high
  blocked_on: step 9, the namespace question, waits for the next decision round
  targets:
    [
      automation/Catzc.Base.Globs/configs/file-kinds.yml,
      automation/Catzc.Base.QualityGates/configs/file-meta.yml,
      automation/Catzc.Base.Variants/types,
      docs/adr/design/tracks.md,
      docs/adr/automation/module-model.md,
    ]
---

# Task: kind becomes role; the track rules

Decided (k8s plan, Q27 to Q38, Q98): Track is the root entity and Module one of its kinds; `kind` takes the Kubernetes-style object meaning,
partitioned by track, and what the file-kinds registry calls kind today (readme, config, adr, agent) becomes `role`. The head key `kind` in
every file then means the object kind. A rename touches the registry, the head processors, the contract schema and every head; it runs
through the generators, never by sweep: change the source once, regenerate, verify.

## Steps

1. [x] Read first, no edit: `file-kinds.yml` (the registry), `file-meta.yml` kind `file-kind` (keys `kind, subkind`), `head.schema.json` and
       `head.sample.yml` in `contracts/catzc/0.0.0`, `languages.yml` `layout:` rows (`role:` is already the word there). List every consumer
       of the key `kind` (`grep -rn "\.kind\b\|\['kind'\]\|kind:" automation --include=*.ps1 --include=*.cs` counted per file) in
       `plan-module-kinds-tracks.md` under a "Rename map" heading. Check: the map exists with counts. Done 2026-10-18 under the plan's
       rename step instead of a new heading, since the plan shape fixes the sections (ADR-REPO-PLANS#3): eight file-kind consumers named
       with counts; the grep's other hits are head lines and unrelated kinds.
2. [x] The Globs types: `FileKindMatch` and `FileKindEntry` say `role` (the entry's name), `Class` is role or role/subkind. Done 2026-10-18
       on the user's go (D24), the peers told first. Correction from the tree: no `Kind` property joins them, since the head already carries
       the object's kind as `tracktype` and `moduletype`, so a second key for it would say one fact twice (ADR-PRIN-ONELIVE); the registry
       keeps its name `file-kinds.yml` and `subkind`, as this task's checks do. Readers moved: `FileKindsConfig`, `Get-ReadmeContent`,
       `Format-GeneratedFileHead`, `GeneratedHeadConfig` and `generated-head.yml` (the required key is `role`).
3. [x] `file-meta.yml`: `file-kind` became `file-role`, `keys: [role, subkind]`, its processor renamed `Get-FileRoleFileMetaFact` with its
       test and comment page; no `object-kind` (step 2's correction). Verdicts: `[Invoke-TestFile] Passed` for FileKindsConfig.Tests,
       Get-FileKind.Tests, GeneratedHeadConfig.Tests, Format-GeneratedFileHead.Tests, Get-FileRoleFileMetaFact.Tests, Format-FileMeta.Tests,
       Test-FileMetaProcessors.Tests, Get-RepoStatusFileMetaFact.Tests, Get-FileMetaFact.Tests and Build-Readme.Tests
       (`out/test-file/20261018-131232` to `-131434`); Test-FileMetaProcessors clean.
4. [x] `head.schema.json` and `head.sample.yml`: `role` replaces `kind` and is required with `path`; the comment says the object's kind is
       `tracktype`. Check: `CONTRACTS issues=0` (`out/test-contracts/20261018-132345`).
5. [x] The heads: the generators rewrote theirs (Build-RootConfig, Build-Glossary, Build-AdrIndex, Build-ContractReference,
       Build-TerminologyDictionary with -PassThru, since its input stamp does not cover the head shape, and the minimap stamp, 447 pages);
       Format-FileMeta held the 37 authored required heads (15 agents, 21 thesis slides, docs/index.md) and the 18 capability heads for a
       decision by hand, as it refuses a key no meta kind owns, so each was edited from `kind:` to `role:` one file at a time. Check:
       `FILEMETA issues=0` and `GENERATED issues=0` (`out/test-file-meta/20261018-132829`, `out/test-generated-files/20261018-132509`); the
       one leftover, `importer-commands.sh` read as authored, was a C5 gap fixed by its `linguist-generated` line in the gitattributes
       template.
6. [x] Docs: file-meta rule 11 bolds **role** (a head writes it as `role`), its File kinds section, and the key in code-file-meta,
       generated-readmes, generated-root-configs and uniform-formatting; the glossary term `kind` became `role` (key `file_role`, defined by
       ADR-REPO-FILEMETA#11) with its six contrasts. `kind` is left free for the object meaning: no rule defines it yet, so it gets no term
       until ADR-AUTO-MODULE or the tracks ADR bolds it. The tracks rule on one primary language is in the tree as ADR-DSGN-TRACK#18. Check:
       `ADRREG issues=0`, `LINKS issues=0` on the six pages; Test-Glossary's 29 findings are the comment pages' `### parameter` headings,
       none from this rename (told to session catzc-e5).
7. [x] `Test-Links` on `automation/Catzc.Base.Docs/types/WorldMapBuilder.cs` (or its current path). Check: zero findings. 2026-10-18: it
       lives in `Catzc.Base.Maps/types`; `LINKS issues=0` (`out/test-links/20261018-122129`).
8. [x] `Test-ShippedTypes` in a fresh process: `TrackTypeEntry` and `VendorEntry` resolve after import, or the reason is fixed in the type
       (Q88). Check: the gate is clean on Catzc.Base.Variants. 2026-10-18: `SHIPPEDTYPES issues=0`
       (`out/test-shipped-types/20261018-122129`).
9. Namespace follow-up (Q36): one Decided line in the plan stating what the namespace of a module is once kinds land (recommendation: the
   track name, so `Catzc.Base.*` stays for the pwsh track) and whether a step follows. Check: the line exists. 2026-10-18: nobody has
   decided it, so the plan carries it as an open question for the next decision round, with the recommendation, not as a Decided line.
10. Tick the plan's five open steps. Check: grep `- [ ]` in `plan-module-kinds-tracks.md` counts zero; the plan then holds only its carried
    drafts and is trimmed by plan-clear (Q11: carried text goes when its data is in the tree).

## Report

As report-fixed, with the diff stat of step 5.
