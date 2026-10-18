---
task:
  status: "steps 3 (read), 4, 5, 6 and 8 done; the rest waits on the user's runs"
  plans: [plan-module-model-closeout, plan-module-kinds-tracks, plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: "the user's Test-Automation run (step 9); D01 to D05 were confirmed 2026-10-18"
  targets:
    [
      automation/Catzc.Base.Modules,
      automation/Catzc.Base.ModuleSystem,
      automation/Catzc.Base.TypesSystem/assets/Catzc.Types.csproj.xml,
      docs/adr/automation/module-model.md,
      docs/references/automation,
    ]
---

# Task: module model close-out

The model landed on 2026-10-16 (Catzc.Base.Modules with Get-CatzcModule and Get-Aspect, Get-ModuleOrder in ModuleSystem, ADR-AUTO-MODULE
with six rules). This closes what the implement run left open. Rule 6 today says a check and a test of a module are resolved by the file
language from the language registry, never by a branch in a command; the open question is whether code enforces it. One file per step; C#
edits need a fresh pwsh; gates in the background under the time safeguard.

## Done before the decisions (2026-10-17), with the corrections the tree forced

- Step 3, the read: checks are resolved by the registry (`Get-ChangeCheckPlan` reads each language's `checks`), and the ADR's "How this is
  enforced" names it; `Test-AdrRegistry` `No adr-registry issues found.` (`out/test-adr-registry/20261017-175653`), Test-Links and
  Test-Markdownlint clean on the ADR (`out/test-links/20261017-175651`, `out/test-markdownlint/20261017-175652`). The tests side still
  branches: `Get-LanguageTestOutcomes` picks the runner by `-Language`; the funnel (a `tests:` entry per test-artifact language) is written
  up in plan-module-model-closeout and follows D03, since it is the rule 6 scope the user confirms.
- Step 4: `Get-CatzcModule -TrackType infrastructure` returns no module; the reason (places below the track root count as internal) and the
  decision it needs are recorded as an open step in plan-module-kinds-tracks.
- Step 5: the reference page `docs/references/automation/catzc-base-modules.md` written in the five-part shape and listed in index.md;
  Format-Code run on it (a dry run changes nothing more), index.md dry run unchanged; `No spelling issues found.`
  (`out/test-spelling/20261017-175756`), `No markdownlint issues found.` (`out/test-markdownlint/20261017-175756`), `No links issues found.`
  on the page; index.md's link to it is `[Untracked]` until the commit.
- Step 6, corrected: the csproj carries no processing instruction any more (its head is the CDATA property of plan-csproj-xml-head), so the
  step's premise is gone; Format-FileMeta then Format-Code both leave its first line, the IDE comment, as it is.
- Step 8: Test-Comments has 11 findings, not 36, all comment pages whose section names a code line the source no longer has; listed with
  their owners in plan-module-model-closeout (three in the file-head plan already, eight in peers' sources of today with no plan). The
  glossary findings are one step of plan-clear-actions.

## Steps

1. [x] Record D01 to D03 in `plan-module-kinds-tracks.md` Decided: replace "taken as recommended, user not yet confirmed" with "confirmed
       2026-10-17 (D01 to D03)" or with the user's change. Check: grep "not yet confirmed" finds nothing. Done 2026-10-18 (D01 to D03
       confirmed in the decision round); the grep finds no such line in plan-module-kinds-tracks.
2. [x] Record D04 in `plan-module-model-closeout.md` and confirm `Copy-Automation.ps1` selects the full profile by default and does not copy
       .scriptanalyzer; adjust the default on its config type if the user chose otherwise. Check: `Copy-Automation.Tests.ps1` passes. Done
       2026-10-18: D04 confirmed, the default unchanged; `[Invoke-TestFile] Passed` (`out/test-file/20261018-121811-11583a`).
3. [x] Rule 6 code: read `languages.yml` `checks:` per language and `Test-Change`; if a language's checks are resolved only through the
       registry there is nothing to build, and the step records the resolving function as the enforcement in the ADR's "How this is
       enforced" section; if any command branches on a language name (grep `-eq 'powershell'`, `switch ($language)` in QualityGates), funnel
       it through the registry, one file at a time. Check: a test names each handler id the rule lists; Test-AdrRegistry clean. Done
       2026-10-18: the checks side already resolved through `checks:` (2026-10-17); the test side branched in `Get-LanguageTestOutcomes` and
       hard-coded go and python in `Get-LanguageTestExecutable`. Both now read a `tests:` entry per test-artifact language in
       `languages.yml` (go and python name their runner, the tools that must resolve and the executable parameter; bash names its runner and
       the bash engine), parsed into the new `LanguageTestRunner` on `FileLanguage` by `LanguagesConfig`, which fails the load on an entry
       with both tools and an engine or neither. The ADR's enforcement section names both functions. Verdicts: `[Invoke-TestFile] Passed`
       for LanguagesConfig.Tests (`out/test-file/20261018-121700-005e49`, two new cases), Get-LanguageTestOutcomes.Tests
       (`20261018-121716-3f288f`, one new case: a language with no entry throws) and Get-LanguageTestExecutable.Tests
       (`20261018-121723-a7df14`); `ANALYZER issues=0`, `SHIPPED issues=0`, `ADRREG issues=0` (`out/test-adr-registry/20261018-121807`),
       `LINKS issues=0`, `MDLINT issues=0` on the ADR.
4. [x] Step 10 of prompt-module-model-2-implement.md, the infrastructure track: read the step; either
       `Get-CatzcModule -TrackType infrastructure` returns the track from variants.yml with a test, or the step is recorded as out of scope
       in `plan-module-kinds-tracks.md` with the reason. Check: the test passes, or the recorded line exists.
5. [x] `docs/references/automation/catzc-base-modules.md`: run the reference generator that builds the sibling module pages (grep how
       `catzc-base-modulesystem.md` is produced: Build-Readme or the comments exporter); if it is hand-authored, write it in that shape and
       list it in `docs/references/automation/index.md`. Check: Test-Links, Test-Spelling clean; Format-Code leaves it unchanged.
6. [x] `Catzc.Types.csproj` first line: run `Format-FileMeta` then `Format-Code` on `automation/.internal/assets/Catzc.Types.csproj` in the
       background and diff the first line after each; the step that drops the processing-instruction name is fixed in its carrier
       (`file-carriers.yml` `msbuild-project`, or `PropertyHead.cs`). Check: both runs leave the first line intact; `PropertyHead.Tests.ps1`
       passes.
7. [x] D05 minimaps: keep means nothing to do but tick; revert means `git checkout` of the slides is the user's. Check: git status under
       `docs/explanation/.assets` lists only the slides meant to change. Done 2026-10-18: D05 keeps the rebuild, so there is nothing to
       revert.
8. [x] The 36 Test-Comments issues and the Test-Glossary bare terms in plan text: list each file with its owning plan in that plan's open
       steps (one line each); none fixed here (D15 for the plan text). Check: Test-Comments and Test-Glossary findings each appear in
       exactly one plan.
9. The user runs the whole Test-Automation and reads the drawio.yml live-yaml test and RootConfig New-GitAttributes failures. Check: the
   run's report lists neither; recorded in the plan.
10. [x] Clear the module-model part of `waits_on` in `plan-config-defaults.md` and `plan-layers-vocabulary-rename-contracts.md`. Check: grep
        waits_on in `.claude/plans` names neither file for the module model. Done 2026-10-18: plan-config-defaults has no `waits_on`, and
        plan-layers-vocabulary-rename-contracts waits only on the P4 go (D10).
11. `plan-module-model-closeout.md`: tick each step; when all are ticked and the decisions are in ADR-AUTO-MODULE, the plan is deleted in
    task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
