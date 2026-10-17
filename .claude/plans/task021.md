---
task:
  id: "021"
  status: done
  plans: [plan-file-head-immutable-edges-classes]
  value: medium-high
  blocked_on: task007 first (it edits file-meta.yml too; one owner at a time)
  targets:
    [
      automation/Catzc.Base.QualityGates/configs/file-meta.yml,
      automation/Catzc.Base.QualityGates/types,
      automation/Catzc.Base.Globs,
      contracts/catzc/0.0.0,
      docs/adr/repository/file-meta.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task021.md"
    folder: plans
    name: task021
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
      - ADR-REPO-FILEMETA#2
---

# task021: class selectors in file-meta.yml, the reachability test, the head schema

Decided Q50: class selectors go now, one kind at a time. The model (carried class-selectors draft): globs are spelled once, in
`file-kinds.yml`; every other front-matter kind selects by `classes` or `languages`, never by its own `files` globs; `files` leaves when no
kind uses it (ADR-PRIN-ONELIVE). Proof: a whole-repo `Format-FileMeta -DryRun` before and after shows zero head changes. Q41: the intended
kind overlaps are written down and FileKindReachability fails on a shadowed kind. Q39: the contract schema stays hand-written.

## Steps

1. [x] Proof baseline: `Format-FileMeta -DryRun` over the tree in the background; save the report under out/. Check: the report exists,
   zero changes (if not, stop: the tree is not clean for this work). Done 2026-10-17: the first dry run listed 13 files, every one a head
   whose derived edges lagged a commit of the same day (the new ADRs, Test-Plans, PlansConfig, the modules and contracts articles,
   function-help.md, task036.md), not a selector fault; `Format-FileMeta` over those 13 (`formatted 12 of 13`), then
   `[Format-FileMeta] File meta: would format 0 of 4041 file(s).`, `DRYRUN changes=0` (`out/t021-dryrun-before.txt`).
2. [x] `FileMetaKind` type: in the tree before this task (correction, 2026-10-17): the type has `select`, a list of `{ classes, languages }`
   selectors (`FileSelector`), no `files` key at all, and its unknown-key check names the kind. Check: not rerun; nothing to change.
3. [x] `Invoke-FileMetaEngine` and `Get-FileMetaFact`: in the tree before this task; kinds select by `FileMetaKind.Selects(class,
   language)`. Check: not rerun; nothing to change.
4. [x] `file-meta.yml`: every kind already selects by `classes` or `languages` or by nothing (every file); no kind spells `files`. The dry
   run of step 1 is the proof (`changes=0`).
5. [x] `Get-AdrCodesFileMetaFact` reads `domain_classes` and `held_classes` (the kind's `ClassSetting`); `relative-edges` rules select by
   `classes`. In the tree before this task.
6. [x] `files` is gone from the type and the config. In the tree before this task.
7. [x] `docs/adr/repository/file-meta.md` rule 2 and `docs/adr/repository/code-meta.md` rule 3: a kind selects by class; file-kind is the
   one glob list. Present tense. Also clear the Test-Markdownlint findings in file-meta.md. Check: Test-AdrRegistry, Test-Links,
   Test-Markdownlint clean. Done 2026-10-17 (correction: the file is `code-file-meta.md`, and both rules already said it; rule 2 and the
   "File kinds" section gained the overlaps sentence, the enforcement list the reachability test): `LINKS file-meta issues=0`,
   `MDLINT file-meta issues=0` (`out/test-links/20261017-193950`, `out/test-markdownlint/20261017-193951`), `ADRREG issues=0`
   (`out/test-adr-registry/20261017-193951`).
8. [x] Q41: `automation/Catzc.Base.Globs/configs/file-kinds.yml` gains an `overlaps:` list (declared once on the config type) naming each
   intended pair; `FileKindReachability.Tests.ps1` fails when a kind is mostly shadowed by an earlier one and the pair is not listed (how
   drawio-kit hid). Check: a fixture with a shadowed kind fails; the real registry passes. Done 2026-10-17: `FileKindsConfig.overlaps`
   (`FileKindOverlap`, validated against the declared kinds and their order), `ShadowedPercent = 50` and `Shadowing(paths)` returning
   `FileKindShadow` records (measured first: `out/t021-shadow.ps1`; fixture, asset, script, reference and explanation are the mostly
   shadowed kinds, 16 pairs listed, `[slide, explanation]` found by the new test itself); the L0 fixture tests and the L2 test.
   `[Invoke-TestFile] Passed` for FileKindsConfig.Tests (`out/test-file/20261017-194430-e95068`); FileKindReachability.Tests: the new
   shadowing test passes, and the one failure is `note`, which no tracked file reaches since `.unordered` was emptied (the user's
   deletion of 2026-10-17, not this task's). ADR-REPO-FILEMETA#2, its "File kinds" section and its enforcement list state the overlaps.
9. [x] `contracts/catzc/0.0.0` `head.schema.json` and `head.sample.yml`: `tracktype` and `vendor` added by hand (Q39). Check:
   `Format-FileMeta.Contract.Tests` passes; Test-Contracts clean. Done 2026-10-17 (correction: the key-set test also wanted `with_inputs_sha`
   and `repo_status`, the generated-head keys, so four keys joined the schema and `repo_status` and `tracktype` the sample):
   `[Invoke-TestFile] Passed` (`out/test-file/20261017-193927-ff97c5`), `CONTRACTS issues=0`.
10. [x] Tick the class-selector, reachability and schema steps in `plan-file-head-immutable-edges-classes.md`. Check: grep `- [ ]` counts
    the task022 leftovers only. Done 2026-10-17: the three steps are ticked with their verdicts; the plan's open checkboxes are the two
    D13 items (automation/.compiled formatting, Q47) and the user's own Test-FileMeta and Test-Automation runs.

## Report

As report-fixed, with the two dry-run reports named.
