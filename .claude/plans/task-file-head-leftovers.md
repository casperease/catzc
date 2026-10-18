---
task:
  status: done
  plans: [plan-file-head-immutable-edges-classes]
  value: medium-high
  blocked_on: nothing; D13 (step 3) and D20 (step 10) were decided 2026-10-18
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
    path: ".claude/plans/task-file-head-leftovers.md"
    folder: plans
    name: task-file-head-leftovers
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
      - ADR-REPO-FORMAT#8
---

# Task: file head leftovers

Small items left by the registry, path-split and formatting sessions, each with a decision already taken (Q45 to Q54, D13). None needs the
others; one file per step; gates in the background. Peers' files (the six Test-Comments findings) are context, not steps (Q48, Q49).

## Steps

1. [x] `glossary.yml`: `note` as a term (Q53), defined by the file-kinds rule that names the kind, domain repository, short form "a tracked
       page that explains without being an ADR, a how-to or a reference". `Build-Glossary`. Check: Test-Glossary clean. Done 2026-10-17
       (correction: the tree's `note` kind is the unordered track's frozen fragment, not a docs page, and no rule bolded the term, so
       ADR-DSGN-TRACK#17 now bolds **note** and the entry is domain design in the ModuleSystem glossary, realized by the file-kinds config
       key); Test-Glossary reports no finding on tracks.md or the glossary sources (`out/t021-checks-c.ps1`, `GLOSSARY issues=229`, all
       elsewhere). The same rule's "an active plan is `out/plan-<topic>.md`" became "lives in `.claude/plans/`" (ADR-REPO-PLANS).
2. [x] Q54: read `docs/adr/automation/asset-dependencies.md` (ADR-AUTO-ASSETDEP); confirm `asset` stays a top-level kind in `file-kinds.yml`
       or move it under the kind the ADR names; record the reading in the plan. Check: the kinds tests pass; one Decided line. Done
       2026-10-17 (correction: the file is `internal-asset-dependencies.md`): the ADR names `assets/` only as a folder a module's code
       reads, never a file kind, so `asset` stays a top-level kind; the Decided line is in plan-file-head-immutable-edges-classes.
3. [x] D13 decided 2026-10-18: skip. `Format-Code` and `Test-Formatting` leave `automation/.compiled` alone as generated output, and the
       formatting ADR names that reading in one sentence. Check: Test-Formatting names no `.compiled` file; Test-Links on the ADR. Done
       2026-10-18: no new attribute; `.gitattributes` already marks `automation/.compiled/** binary`, so Get-FormatScope leaves out every
       `binary` file beside the vendored and contract classes, and ADR-REPO-FORMAT#8 names the binary class with `.compiled` as its example.
       `Get-FormatScope.Tests.ps1` 3 of 3; `Test-Formatting -Language json` names no `.compiled` file (its two findings are the two VSCode
       extension `package.json` files, not this work); `LINKS issues=0` on the ADR.
4. [x] `automation/Catzc.Base.Variants/configs/module-types.yml` line 22: "under ex. automation" becomes "under the track folder" (Q46; the
       user approved the next holder fixing it). Check: grep "under ex." finds nothing; the config tests pass. Done 2026-10-17: grep finds
       nothing; the ModuleTypesConfig test verdict is in this task's report.
5. [x] Test-Spelling in the background; add `catzc_bundle` to the coined words only if the report flags it. Check: the report does not list
       it. Done 2026-10-17: `SPELL issues=28`, none `catzc_bundle`; every finding is a peer's (watchpoint in Timeouts and QualityGates,
       vsixmanifest in VSCode, msbuild in two configs, apos in Slides, isinst, ints, ildasm and Diagnoser in reference-unboxing.md, CMDB in
       record.slide.md, ncatzc in Invoke-FileMetaEngine.Tests).
6. [x] Test-FileMeta, Test-Glossary, Test-Contracts, Test-GeneratedFiles, one background script each; read each report and attribute every
       finding to this work or to a peer in the plan. Check: four reports read; attributions written. Done 2026-10-17: the attribution is
       the ticked "Checks not run" item of plan-file-head-immutable-edges-classes (`out/test-file-meta/20261017-194711`,
       `out/test-glossary/20261017-194719`, `out/test-generated-files/20261017-194644`, Test-Contracts `issues=0`).
7. Context, no step: the six Test-Comments findings in peers' files (PropertyHead.cs.md, MarkdownMetaBlock.cs.md, file-meta.yml.md,
   PathParts.cs:67, ModulePlace.cs:68) are theirs; the untracked Get-AutomationSourceFiles.ps1.md page is the user's staging call.
8. [x] Tick every leftover step in `plan-file-head-immutable-edges-classes.md`; the plan is then trimmed of its carried drafts (their data
       is in the tree) and deleted in task-closing-sweep. Check: grep `- [ ]` counts zero. Done 2026-10-17 as far as the decisions allow:
       the grep counts the two D13 items (step 3 here, Q47 there) and the user's own gate runs; the trim and the deletion stay with
       task-closing-sweep.
9. [x] The four QualityGates tool candidates of the out/ harvest (out-artifacts): `run-head-batch` (stamps heads and proves a set),
       `diff-one` (one file's head diff), `probe-corpus` (loads the git-HEAD version of a private function for a refactor-equivalence check)
       and `gates-module` (a per-module gate runner): each becomes a module function with tests, or is recorded here as not needed with the
       reason. Check: the four names are each a function with a Pester file, or a recorded line. Done 2026-10-18, all four not needed:
   - `run-head-batch`: bound to one rollout's list file (`head-all-changed.txt`); its general part is `Format-FileMeta` then
     `Format-FileMeta -DryRun -PassThru` changing nothing, which the command and its tests already prove.
   - `diff-one`: `Format-FileMeta -Path <file> -DryRun -PassThru` reports one file's head change through the public command, without
     reaching into the private engine.
   - `probe-corpus`: hard-wired to one refactor of `Get-TerminologyCorpus`; equivalence across a refactor is a test of the function's
     behaviour, written in its Pester file, not a generic loader of old code.
   - `gates-module`: `Test-Change -Path automation/<Module> -WholeModule` runs the module's tests and the checks its files' languages
     configure (Get-ChangeCheckPlan), so a hand list of gates would be a second source.
10. [x] D20 decided 2026-10-18: the `note` file kind goes. First a page for its meaning (never drop a key silently), then the kind leaves
        `file-kinds.yml` and its `overlaps` pair, ADR-DSGN-TRACK#17 stops bolding **note**, the glossary term and its contrasts go, and the
        reachability test is green without an exemption. Check: `FileKindsConfig.Tests.ps1` and `FileKindReachability.Tests.ps1` pass;
        Test-Glossary and Test-Links clean on the touched pages. Done 2026-10-18 (correction: the kind had no `overlaps` pair). The kind's
        `catzc-notes` attribute was the content tools' exemption for `.unordered/`; the user chose 2026-10-18 to move it to the track: the
        `unordered` track type declares `git: { attributes: [catzc-unordered], why }` (TrackTypesConfig and TrackTypeEntry read it),
        `New-GitAttributes` writes `.unordered/** catzc-unordered` per place of each track of that type, and Get-ContentExemptPath and
        source-conventions.yml name the class. The page is `docs/references/note-file-kind.md`. Verdicts: TrackTypesConfig 11/11,
        New-GitAttributes 7/7, Get-ContentExemptPath 4/4, FileKindsConfig 37/37, FileKindReachability 39/39; Build-RootConfig wrote line 137
        `.unordered/** catzc-unordered`; `GLOSSARY issues=0`, `LINKS issues=0`, `MDLINT issues=0`.

## Report

As report-fixed.
