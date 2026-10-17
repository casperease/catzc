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
---

# task022: file head leftovers

Small items left by the registry, path-split and formatting sessions, each with a decision already taken (Q45 to Q54, D13). None needs the
others; one file per step; gates in the background. Peers' files (the six Test-Comments findings) are context, not steps (Q48, Q49).

## Steps

1. `glossary.yml`: `note` as a term (Q53), defined by the file-kinds rule that names the kind, domain repository, short form "a tracked
   page that explains without being an ADR, a how-to or a reference". `Build-Glossary`. Check: Test-Glossary clean.
2. Q54: read `docs/adr/automation/asset-dependencies.md` (ADR-AUTO-ASSETDEP); confirm `asset` stays a top-level kind in `file-kinds.yml` or
   move it under the kind the ADR names; record the reading in the plan. Check: the kinds tests pass; one Decided line.
3. D13: if skip, `Format-Code` and `Test-Formatting` exclude `automation/.compiled` through the formatting config (declared once, with its
   reason: generated output); if amend, `docs/adr/repository/uniform-formatting.md` gains the sentence that covers the folder. Check:
   Test-Formatting names no `.compiled` file, or the ADR sentence exists.
4. `automation/Catzc.Base.Variants/configs/module-types.yml` line 22: "under ex. automation" becomes "under the track folder" (Q46; the user
   approved the next holder fixing it). Check: grep "under ex." finds nothing; the config tests pass.
5. Test-Spelling in the background; add `catzc_bundle` to the coined words only if the report flags it. Check: the report does not list it.
6. Test-FileMeta, Test-Glossary, Test-Contracts, Test-GeneratedFiles, one background script each; read each report and attribute every
   finding to this work or to a peer in the plan. Check: four reports read; attributions written.
7. Context, no step: the six Test-Comments findings in peers' files (PropertyHead.cs.md, MarkdownMetaBlock.cs.md, file-meta.yml.md,
   PathParts.cs:67, ModulePlace.cs:68) are theirs; the untracked Get-AutomationSourceFiles.ps1.md page is the user's staging call.
8. Tick every leftover step in `plan-file-head-immutable-edges-classes.md`; the plan is then trimmed of its carried drafts (their data is in
   the tree) and deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
