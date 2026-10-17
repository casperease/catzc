---
plan:
  status: active
  value: high
  reviewed: 2026-10-17
  next: the user confirms the three module-model choices and the Copy-Automation default; then the handler ids for rule 6
  targets:
    [automation/Catzc.Base.Modules, automation/Catzc.Base.ModuleSystem, docs/adr/automation/module-model.md, docs/references/automation]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-module-model-closeout.md"
    folder: plans
    name: plan-module-model-closeout
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Module model: close-out after the implement run

The module model landed on 2026-10-16 (see plan-module-kinds-tracks): Get-CatzcModule and Get-Aspect in Catzc.Base.Modules, Get-ModuleOrder
in ModuleSystem, ADR-AUTO-MODULE with six rules, the old getters and types deleted. This plan holds what that run left open and what the
verification found.

## Decided

- The reference pages of ModuleSystem and TypesSystem, the READMEs built from them, the comment pages of the deleted sources and the
  module-graph diagram with its two description pages follow the new names (2026-10-17).
- The run-mode slides' minimaps are rebuilt from the current citations; the rebuild redrew every slide's minimaps under
  docs/.assets/explanation, and Test-Links and Test-GeneratedFiles are clean there.

## Done

- Tests of the new files pass (Module, Get-Aspect, Get-CatzcModule, Get-ModuleOrder); Test-FileMeta, Test-ScriptAnalyzer and Test-Links are
  clean on them; the Test-InIsolation mock carries the full profile.
- Test-GeneratedFiles is clean after Build-Readme; Export-Comments moved the last two comments of Module.cs and Copy-Automation.ps1.

## Open steps

- [ ] The user confirms the three choices recorded in plan-module-kinds-tracks (resolver module, execution_engines key, rule 6 scope)
      (check: the "user not yet confirmed" wording is gone from that plan's Decided list).
- [ ] The user confirms that Copy-Automation selects the full profile by default, which no longer copies .scriptanalyzer (check:
      Copy-Automation.Tests.ps1 passes with the confirmed default).
- [ ] Rule 6 of ADR-AUTO-MODULE gets code: build and test handler ids on the track, or the rule is narrowed to what exists (check:
      Test-AdrRegistry clean; a test names each handler id the rule lists).
- [ ] Step 10 of the implement prompt, the infrastructure track (check: Get-CatzcModule -TrackType returns it, or the step is recorded as
      out of scope in plan-module-kinds-tracks).
- [ ] Catzc.Base.Modules gets its reference page (check: docs/references/automation/catzc-base-modules.md exists, listed in index.md, and
      Test-Links, Test-Spelling and Format-Code are clean on it).
- [ ] Clear the waits_on lines in plan-config-defaults and plan-layers-vocabulary-rename-contracts once the first two steps are done (check:
      grep waits_on in .claude/plans shows neither file).
- [ ] The user runs the whole Test-Automation and reads the two real-repo failures an agent reported (the drawio.yml live-yaml test and
      RootConfig New-GitAttributes) (check: the run's report lists neither).
- [ ] The head of automation/.internal/assets/Catzc.Types.csproj lost its processing-instruction name once (`<?catzc` became `<?`); find
      which imprint step does it (check: Format-FileMeta then Format-Code on that file leave the first line `<?catzc`).
- [ ] Decide the minimaps of the other slides: keep the rebuild or revert it (check: git status under docs/.assets/explanation lists only
      the slides meant to change).
- [ ] Test-Comments lists 36 issues in files outside this change and Test-Glossary flags bare terms in plan text; clear them in their
      owners' plans (check: Test-Comments and Test-Glossary report none).
- [ ] Delete this plan when the steps above are done and the decisions live in ADR-AUTO-MODULE (check: no file in .claude/plans names it).

## Refs

- plan-module-kinds-tracks (owns the model and the carried drafts), prompt-module-model-2-implement
- docs/adr/automation/module-model.md (ADR-AUTO-MODULE), docs/adr/design/tracks.md (rule 18)
