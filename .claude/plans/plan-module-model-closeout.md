---
plan:
  status: active
  value: high
  reviewed: 2026-10-17
  next: the handler ids for rule 6 (task-module-model-closeout)
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

- [x] The user confirms the three choices recorded in plan-module-kinds-tracks (resolver module, execution_engines key, rule 6 scope)
      (check: the "user not yet confirmed" wording is gone from that plan's Decided list). Confirmed 2026-10-18 (D01 to D03).
- [x] The user confirms that Copy-Automation selects the full profile by default, which no longer copies .scriptanalyzer (check:
      Copy-Automation.Tests.ps1 passes with the confirmed default). Confirmed 2026-10-18 (D04); the tests already hold that default.
- [ ] Rule 6 of ADR-AUTO-MODULE gets code: build and test handler ids on the track, or the rule is narrowed to what exists (check:
      Test-AdrRegistry clean; a test names each handler id the rule lists). Read 2026-10-17 (its task): the checks side holds, every
      language's gates come from its `checks` list in languages.yml through `Get-ChangeCheckPlan`, and the ADR's enforcement section now
      names it (Test-AdrRegistry clean, `out/test-adr-registry/20261017-175653`). The tests side has one branch left:
      `Get-LanguageTestOutcomes` picks `Invoke-GoTest`, `Invoke-PythonTest` or `Invoke-BashTest` by `-Language` (a `ValidateSet` of the
      three names, a tool map `go`, `uv`, `bash`, and three executable parameter names); `Get-PythonCheckScope` only filters folders by the
      registry's language name. The funnel is a `tests:` entry per test-artifact language in languages.yml naming the runner, its tool and
      the executable parameter, read by LanguagesConfig and dispatched by the one function; it follows D03 (rule 6 covers test handlers).
- [x] Step 10 of the implement prompt, the infrastructure track. Recorded 2026-10-17 (its task) in plan-module-kinds-tracks: the track and
      its type are declared and deployable, but `Get-CatzcModule -TrackType infrastructure` returns no module, because the bicep module
      type's places (`infrastructure/templates`, `infrastructure/modules`) sit below the track's place `infrastructure` and the resolver
      treats a nested place as internal unless `-IncludeInternal`; the extension is a design step there (check: the recorded line exists).
- [x] Catzc.Base.Modules gets its reference page. Done 2026-10-17 (its task): `docs/references/automation/catzc-base-modules.md`, two
      responsibilities (module resolution, aspect classification), listed in index.md. Check: Format-Code run on it and a dry run changes
      nothing more, index.md dry run unchanged; Test-Spelling, Test-Markdownlint, Test-Links clean (`out/test-spelling/20261017-175756`,
      `out/test-markdownlint/20261017-175756`); index.md's link to it reports `[Untracked]` until the page is committed.
- [ ] Clear the waits_on lines in plan-config-defaults and plan-layers-vocabulary-rename-contracts once the first two steps are done (check:
      grep waits_on in .claude/plans shows neither file).
- [ ] The user runs the whole Test-Automation and reads the two real-repo failures an agent reported (the drawio.yml live-yaml test and
      RootConfig New-GitAttributes) (check: the run's report lists neither).
- [x] The head of automation/.internal/assets/Catzc.Types.csproj. Done 2026-10-17 (its task): the file no longer carries a processing
      instruction; its head is the CDATA `CatzcMeta` property of the `msbuild-project` carrier (plan-csproj-xml-head), and its first line is
      the IDE comment `<!--`. Format-FileMeta then Format-Code both left that first line as it was (`out/t011-csproj-first-line.ps1`).
- [x] Decide the minimaps of the other slides: keep the rebuild or revert it (check: git status under docs/.assets/explanation lists only
      the slides meant to change). Decided 2026-10-18 (D05): keep the rebuild.
- [ ] Test-Comments lists 36 issues in files outside this change and Test-Glossary flags bare terms in plan text; clear them in their
      owners' plans (check: Test-Comments and Test-Glossary report none). Counted 2026-10-17 (its task): Test-Comments has 11 issues left,
      every one a comment page whose section names a code line the file no longer has (`out/test-comments/20261017-175227`):
      `PropertyHead.cs.md`, `MarkdownMetaBlock.cs.md` (2) and `file-meta.yml.md`, already context lines of
      plan-file-head-immutable-edges-classes (Q48); `MarkdownDocument.cs.md`, `ConsoleText.cs.md` (2), `DictionaryRecord.cs.md`,
      `Get-ModuleGlobSet.ps1.md`, `Catzc.Internal.Importer.psm1.md` and `Catzc.Internal.Builder.psm1.md`, whose sources peers edited today
      and no plan owns; the fix is Export-Comments by whoever next holds each source. The glossary findings are one step of
      plan-clear-actions, file by file.
- [ ] Delete this plan when the steps above are done and the decisions live in ADR-AUTO-MODULE (check: no file in .claude/plans names it).

## Refs

- plan-module-kinds-tracks (owns the model and the carried drafts), prompt-module-model-2-implement
- docs/adr/automation/module-model.md (ADR-AUTO-MODULE), docs/adr/design/tracks.md (rule 18)
