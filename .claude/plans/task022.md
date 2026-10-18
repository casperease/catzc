---
task:
  id: "022"
  status: open
  plans: [plan-file-head-immutable-edges-classes]
  value: medium-high
  blocked_on: D13 for step 3; the rest can start now
  targets:
    [
      automation/Catzc.Base.Docs/configs/glossary.yml,
      automation/Catzc.Base.Globs/configs/file-kinds.yml,
      automation/Catzc.Base.Variants/configs/module-types.yml,
      automation/Catzc.Base.Languages,
      docs/adr/repository/uniform-formatting.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task022.md"
    folder: plans
    name: task022
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
      - ADR-DSGN-TRACK#17
---

# task022: file head leftovers

Small items left by the registry, path-split and formatting sessions, each with a decision already taken (Q45 to Q54, D13). None needs the
others; one file per step; gates in the background. Peers' files (the six Test-Comments findings) are context, not steps (Q48, Q49).

## Steps

1. [x] `glossary.yml`: `note` as a term (Q53), defined by the file-kinds rule that names the kind, domain repository, short form "a tracked
   page that explains without being an ADR, a how-to or a reference". `Build-Glossary`. Check: Test-Glossary clean. Done 2026-10-17
   (correction: the tree's `note` kind is the unordered track's frozen fragment, not a docs page, and no rule bolded the term, so
   ADR-DSGN-TRACK#17 now bolds **note** and the entry is domain design in the ModuleSystem glossary, realized by the file-kinds config key);
   Test-Glossary reports no finding on tracks.md or the glossary sources (`out/t021-checks-c.ps1`, `GLOSSARY issues=229`, all elsewhere).
   The same rule's "an active plan is `out/plan-<topic>.md`" became "lives in `.claude/plans/`" (ADR-REPO-PLANS).
2. [x] Q54: read `docs/adr/automation/asset-dependencies.md` (ADR-AUTO-ASSETDEP); confirm `asset` stays a top-level kind in
   `file-kinds.yml` or move it under the kind the ADR names; record the reading in the plan. Check: the kinds tests pass; one Decided line.
   Done 2026-10-17 (correction: the file is `internal-asset-dependencies.md`): the ADR names `assets/` only as a folder a module's code
   reads, never a file kind, so `asset` stays a top-level kind; the Decided line is in plan-file-head-immutable-edges-classes.
3. D13, open: waits for the user's decision (skip or amend); nothing done.
4. [x] `automation/Catzc.Base.Variants/configs/module-types.yml` line 22: "under ex. automation" becomes "under the track folder" (Q46; the
   user approved the next holder fixing it). Check: grep "under ex." finds nothing; the config tests pass. Done 2026-10-17: grep finds
   nothing; the ModuleTypesConfig test verdict is in the task022 report.
5. [x] Test-Spelling in the background; add `catzc_bundle` to the coined words only if the report flags it. Check: the report does not list
   it. Done 2026-10-17: `SPELL issues=28`, none `catzc_bundle`; every finding is a peer's (watchpoint in Timeouts and QualityGates,
   vsixmanifest in VSCode, msbuild in two configs, apos in Slides, isinst, ints, ildasm and Diagnoser in reference-unboxing.md, CMDB in
   record.slide.md, ncatzc in Invoke-FileMetaEngine.Tests).
6. [x] Test-FileMeta, Test-Glossary, Test-Contracts, Test-GeneratedFiles, one background script each; read each report and attribute every
   finding to this work or to a peer in the plan. Check: four reports read; attributions written. Done 2026-10-17: the attribution is the
   ticked "Checks not run" item of plan-file-head-immutable-edges-classes (`out/test-file-meta/20261017-194711`,
   `out/test-glossary/20261017-194719`, `out/test-generated-files/20261017-194644`, Test-Contracts `issues=0`).
7. Context, no step: the six Test-Comments findings in peers' files (PropertyHead.cs.md, MarkdownMetaBlock.cs.md, file-meta.yml.md,
   PathParts.cs:67, ModulePlace.cs:68) are theirs; the untracked Get-AutomationSourceFiles.ps1.md page is the user's staging call.
8. [x] Tick every leftover step in `plan-file-head-immutable-edges-classes.md`; the plan is then trimmed of its carried drafts (their data is
   in the tree) and deleted in T036. Check: grep `- [ ]` counts zero. Done 2026-10-17 as far as the decisions allow: the grep counts the
   two D13 items (step 3 here, Q47 there) and the user's own gate runs; the trim and the deletion stay with T036.
9. The four QualityGates tool candidates of the out/ harvest (task028 step 7): `run-head-batch` (stamps heads and proves a set), `diff-one`
   (one file's head diff), `probe-corpus` (loads the git-HEAD version of a private function for a refactor-equivalence check) and
   `gates-module` (a per-module gate runner): each becomes a module function with tests, or is recorded here as not needed with the
   reason. Check: the four names are each a function with a Pester file, or a recorded line.

## Report

As report-fixed.
