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
---

# task022: file head leftovers

Small items left by the registry, path-split and formatting sessions, each with a decision already taken (Q45 to Q54, D13). None needs the
others; one file per step; gates in the background. Peers' files (the six Test-Comments findings) are context, not steps (Q48, Q49).

## Steps

1. `glossary.yml`: `note` as a term (Q53), defined by the file-kinds rule that names the kind, domain repository, short form "a tracked page
   that explains without being an ADR, a how-to or a reference". `Build-Glossary`. Check: Test-Glossary clean.
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
6. Test-FileMeta, Test-Glossary, Test-Contracts, Test-GeneratedFiles, one background script each; read each report and attribute every
   finding to this work or to a peer in the plan. Check: four reports read; attributions written.
7. Context, no step: the six Test-Comments findings in peers' files (PropertyHead.cs.md, MarkdownMetaBlock.cs.md, file-meta.yml.md,
   PathParts.cs:67, ModulePlace.cs:68) are theirs; the untracked Get-AutomationSourceFiles.ps1.md page is the user's staging call.
8. Tick every leftover step in `plan-file-head-immutable-edges-classes.md`; the plan is then trimmed of its carried drafts (their data is in
   the tree) and deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
