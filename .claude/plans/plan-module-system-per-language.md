---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets:
    [
      pwsh/Catzc.Base.Variants/configs/module-types.yml,
      pwsh/Catzc.Base.Variants/configs/track-types.yml,
      pwsh/Catzc.Base.Variants/configs/variants.yml,
      pwsh/Catzc.Base.Variants/types/ModulePlace.cs,
      pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs,
      pwsh/Catzc.Base.Languages/configs/languages.yml,
      pwsh/Catzc.Base.Languages/configs/python.yml,
      pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs,
      pwsh/Catzc.Base.Languages/types/PythonConfig.cs,
      pwsh/Catzc.Base.Languages/New-PythonProject.ps1,
      pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1,
      pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1,
      pwsh/Catzc.Base.Languages/Invoke-GoTest.ps1,
      pwsh/Catzc.Base.Languages/Invoke-BashTest.ps1,
      pwsh/Catzc.Base.Modules/Get-CatzcModule.ps1,
      pwsh/Catzc.Base.Modules/Get-Aspect.ps1,
      pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1,
      pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1,
      pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs,
      pwsh/Catzc.Base.Exporter/Assert-CatzcBundle.ps1,
      pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml,
      docs/adr/automation/module-model.md,
      docs/adr/design/track-types.md,
      docs/adr/design/module-types.md,
      docs/adr/automation/python/python-test-artifacts.md,
      docs/adr/automation/go/go-test-artifacts.md,
      docs/adr/automation/bash/bash-test-artifacts.md,
    ]
---

# The module system per language: every language track holds modules the way pwsh does

The module model is generic on paper (a track declared once, a track type with a role and the module types it admits, a module type with its
places, a layout per file language) and pwsh-shaped in practice: only the pwsh track holds modules, the other language tracks are each one
holder module of test projects, and three commands branch on the `modules` id. This plan makes one mechanism serve every language track,
pwsh, python, go, bash and a future javascript alike, with each language's particulars in that language's own config. It runs before the
diagram track, whose Python module `python/Catzc.Diagrams` is the first module outside pwsh (`plan-diagram-engine` waits on it).

## Why its value is high

The diagram engine cannot land as a module until a language track can hold one, and every later language (javascript is the next candidate)
would otherwise repeat the pwsh-only shape.

## Decided (2026-10-19, from the user)

- This plan runs first; no diagram work starts until it is done. `plan-diagram-engine` is blocked on it.
- pwsh is one language among the languages of the repository. That its modules carry the tooling gives it no shape of its own in the model:
  what the pwsh track does, every language track does.
- A language track (pwsh, python, go, bash, a future javascript) holds modules and tests the same way; the python track holds generalized
  Python modules and tests.
- A new language is entries in the registries and one config of its own (`python.yml`, `go.yml`, `bash.yml`, a `javascript.yml`), never a
  branch on a language or a track-type id in a command (ADR-AUTO-MODULE-CHECKSBYLANGUAGE, ADR-AUTO-EXTEND).

## Proposed shape (recommendations; each becomes a rule when its step lands, ADR-REPO-PLANS-DECISIONSBECOMERULES)

- A module of a language track is a non-dot folder directly under the track's root, named by the folder, as `pwsh-folder` is today: the
  `python`, `go` and `bash` module types get a folder place ahead of their root place. The root place stays and names the track's own module
  (`python`), which holds what no folder module holds: the black-box test holder `<root>/tests/<kebab>` (ADR-AUTO-PY-ONEPYTHONROOT keeps it,
  as the Go `go.work` parity does) and the generated project files.
- A folder place declares the folders that are the track's own, `except: [tests]`, so the test holder never resolves as a module named
  `tests`; the key is read on the place, so a language whose holder is named otherwise declares it there.
- The `verification` track type retires (ADR-PRIN-ONELIVE): a language track is a `modules` track, deployable in role, and what ships is
  what `files.yml` packages; a module with no package ships nothing, and a test file is never live by the layout's `tests` row. The
  `modules` definition drops "PowerShell and C#" and admits `python`, `go` and `bash`.
- Each language's layout rows live under the language in `languages.yml` (python: `.py` at the root, role `script`; go: `.go` at the root,
  role `source`; bash: `.sh` at the root, role `script`); the shared rows `assets/` and `tests/`, the yaml `configs/` and the C# `types/`
  apply to every module as they do today.
- Each language's `tests` entry in `languages.yml` names its test-file pattern beside its runner, and the language's config names its root,
  so test discovery and project generation read the registry and never a literal list of languages.
- A module's own `tests/` folder in a language track is run as that module's tests, through the same bridge as the holder's folders.
- The commands that branch on the `modules` id anchor on facts instead: the catzc modules folder for the anchor, the primary language's
  layout rows for the aspects.

## Survey (checked 2026-10-19)

- `track-types.yml:2-5` defines `modules` as PowerShell and C# and admits only `pwsh-folder` and `pwsh-psm1`; `:30-33` `verification` admits
  `python`, `go`, `bash`.
- `module-types.yml` gives `python`, `go` and `bash` one root place each (`{ root: python, name: root }`), so a whole track is one module.
- `languages.yml` has layout rows for powershell, csharp, yaml and markdown only.
- `Get-CatzcModule.ps1:31-33` lists deployable-role tracks only and `:47` anchors on the literal `modules` id; `Get-Aspect.ps1:15` branches
  on the same id; `Get-LanguageTestFolders.ps1:8-12` lists the three languages with their roots and patterns by hand and `:16` maps a test
  folder to a `-TrackType modules` module by kebab name; `Invoke-PythonTest.ps1:22` runs `<root>/tests/<kebab>` only.
- `New-PythonProject.ps1` makes `python/tests/*` the workspace members and reaches other Python folders through `python.yml` `extra_paths`
  (today `.claude/drawio`); `New-GoWorkspace.ps1` is the Go counterpart.
- `WorldMapBuilder.cs:135` never-live types are `verification` and `vendored-code`; `Get-FileLanguage.Tests.ps1:85` and
  `Assert-CatzcBundle.ps1:37` name `verification`; the glossary defines "verification track"
  (`Catzc.Base.ModuleSystem/configs/glossary.yml:100`).
- ADR text that states the pwsh-only shape: ADR-AUTO-PY-TESTARTIFACTSONLY, ADR-AUTO-GO-TESTARTIFACTSONLY, ADR-AUTO-BASH-TESTARTIFACTSONLY,
  ADR-DSGN-TRACKTYPE-CLOSEDSETOFTYPES (the type list), ADR-DSGN-MODTYPE-TRACKTYPEADMITSMODULETYPES (the admits list),
  ADR-DSGN-MODTYPE-DEPLOYABLEORHOLDERMODULE (one module per holder track).

## Done (2026-10-19) and why

- `ModulePlace.cs` and `ModuleTypesConfig.cs`: a folder place takes `except`, the folders under its root that are the track's own
  (`ModuleTypesConfig.Tests.ps1`: `[Invoke-TestFile] Passed (in-place)`, 19:46).
- `module-types.yml`: `python`, `go` and `bash` hold folder modules, `except: [tests]`, ahead of the track's own root module
  (`Get-PathModule.Tests.ps1`: `[Invoke-TestFile] Passed (in-place)`, 19:47).
- `track-types.yml` and `variants.yml`: `verification` retired; the three tracks are `modules`, which admits their module types
  (`Test-TrackDeclaration: no violations`; `TrackTypesConfig`, `Test-TrackDeclaration`, `VariantsConfig`, `Get-FileLanguage` tests:
  `[Invoke-TestFile] Passed (in-place)`, 19:48).
- `languages.yml` and `LanguagesConfig.cs`: root layout rows for python, go and bash; `pattern` on every `tests` entry; `IsLaidOut`, true
  when a track's primary language owns a live layout row, so markdown's readme row lays out nothing (`LanguagesConfig.Tests.ps1`:
  `[Invoke-TestFile] Passed (in-place)`, 20:04).
- `Get-CatzcModule.ps1`: the relocatable anchor is the track whose modules run under this engine (`execution_engines`), never the type id; a
  root module holds what no folder place, nested track or dot folder holds; `-EngineTrack` selects that track, which is what every caller of
  `-TrackType modules` meant now that the three language tracks are `modules` too (`Get-CatzcModule.Tests.ps1`, with the third-language
  fixture track `shelves`, the javascript rehearsal: `[Invoke-TestFile] Passed (in-place)`, 19:55). The fourteen callers re-pointed, one
  file each: `Copy-CatzcModule`, `Get-ModuleFunction`, `Get-ModuleOrder`, `Get-ModuleProfile`, `Get-ModuleDependencyMap`,
  `Get-ModuleDependencyViolations`, `Resolve-ImportMix`, `Test-FolderConventions`, `Get-LanguageTestFolders`, `Test-Automation`,
  `Test-BuildArtifact`, `Test-CatzcBuild`, `Get-ContractCommandRoot`, `Get-CSharpTypeDependency`, and their tests' mocks (ten test files:
  `[Invoke-TestFile] Passed (in-place)`, 19:58 and 20:02). `dependencies.yml` declares `Catzc.Base.Engines` for `Catzc.Base.Modules`.
- `Get-Aspect.ps1`, `Get-WorldMap.ps1`, `Get-ModuleGlobSet.ps1`, `WorldMapBuilder.cs`: the laid-out check and the modules folder replace the
  `modules` id; `verification` is no longer a never-live type (`Get-Aspect`, `Get-WorldMap`, `Test-WorldMap`, `Get-WorldMapHighlight`,
  `WorldMapBuilder`, `Get-ModuleGlobSet` tests: `[Invoke-TestFile] Passed (in-place)`, 20:02 and 20:04).
- `pwsh/.scriptanalyzer/NoTrackRootLiteral.psm1`: the roots no string may spell are the engine track's places, read by `execution_engines`,
  so the 93 fixture literals `python/`, `go/` and `bash/` in tests stay legal (check owed: `Test-ScriptAnalyzer` on one file).

- `Get-LanguageTestFolders.ps1`: the languages come from the registry (`tests` runner, its `pattern`), each root from the language's own
  config, and a module's own `tests/` folder yields a record beside the holder's (`Get-LanguageTestFolders.Tests.ps1`:
  `[Invoke-TestFile] Passed (in-place)`, 20:08).
- `Invoke-PythonTest.ps1`, `Invoke-GoTest.ps1`, `Invoke-BashTest.ps1`: `-Folder` runs the folder the record names, the holder's or a
  module's own, with the generated member file at the module root; `Get-LanguageTestOutcomes` and `Language.Bridge.ps1` hand the folder down
  (the three runners' tests and `Get-LanguageTestOutcomes.Tests.ps1`: `[Invoke-TestFile] Passed (in-place)`, 20:10).
- `New-PythonProject.ps1`, `PythonConfig.cs`, `python.yml`, `Invoke-RootConfigGenerator.ps1`: every module folder of the python track is a
  workspace member with its `pyproject.toml` at the module root; `extra_paths` is gone from the config, the type, the workspace and the
  editor settings. `New-GoWorkspace.ps1`, `GoConfig.cs`, `go.yml`: every module folder of the go track is a `go.work` member with its
  `go.mod`; `module_root` is `catzc/go`, the holder's modules `<module_root>/tests/<folder>` as before. `rootconfig.yml` adds the two
  module-member targets (`New-PythonProject`, `PythonConfig`, `New-GoWorkspace`, `GoConfig`, `Build-RootConfig` tests:
  `[Invoke-TestFile] Passed (snapshot)`, 20:15).
- `Assert-CatzcBundle.ps1`: the comment names the layout. `Test-ModuleDependency`: `No module-dependency issues found.` (20:07), which
  clears the two undeclared type dependencies the holder modules had caused; `Test-ScriptAnalyzer` on the resolver and the re-pointed
  commands: `No script-analyzer issues found.` (20:07).
- The ADRs: ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE with its section and enforcement; ADR-DSGN-TRACKTYPE-CLOSEDSETOFTYPES,
  ADR-DSGN-TRACK-ONETRACKTYPE and ADR-DSGN-TRACK-STACKVIOLATION without `verification`; ADR-DSGN-MODTYPE-TRACKTYPEADMITSMODULETYPES and
  ADR-DSGN-MODTYPE-DEPLOYABLEORHOLDERMODULE with the language track's own module; ADR-AUTO-PY-TESTARTIFACTSONLY,
  ADR-AUTO-GO-TESTARTIFACTSONLY and ADR-AUTO-BASH-TESTARTIFACTSONLY retired for `*-MODULESBYLAYOUT`, the one citing article re-pointed by
  hand; the glossary's "verification track" retired for "language track" (`Test-AdrRegistry`: `No adr-registry issues found.`; `Test-Links`
  on the changed pages, the index and the glossary: `No links issues found.`, 20:23; `Build-AdrIndex` and `Build-Glossary` rerun).
  `Test-Glossary` reports two `G6` wordings in `docs/adr/flow/cd-discipline-and-promotion-flow.md:449` and
  `docs/adr/flow/pipeline-concept.md:53`, files of other sessions, none of this plan's.
- The heads step was moot: no tracked file of the three tracks carries a head (checked by grep, 2026-10-19).

- The generated pages: `Format-Code` over the touched sources rewrote their comment pages, five new parameters got their help subsection by
  hand (`-Folder` on the three runners and `Get-LanguageTestOutcomes`, `-EngineTrack` on `Get-CatzcModule`), three pages re-point the code
  line their comment sits above, and the Maps reference article drops the retired type (`Test-Comments` on the touched sources:
  `No comments issues found.`; `Test-GeneratedFiles`: `No generated-files issues found.`; `Test-Links` on the pages:
  `No links issues found.`, 20:27). Left as found: `Resolve-ImportMix.ps1` has no comment page for its help, a file of the importer-mix
  session.

## Open steps

- [ ] `plan-diagram-engine`'s first step rewrites `out/run-user-git-diagrams.ps1` so `.claude/drawio` lands in the python layout: `*.py` at
      the module root, `configs/drawio.yml`, `assets/` for the xml, html and style guide, `tests/` for the three test files (check: the
      diagram plan's step names the folders; this plan is then done and deleted, ADR-REPO-PLANS-DONEPLANDELETED).

## Refs

- `plan-diagram-engine`: its first step moves `.claude/drawio` to `python/Catzc.Diagrams`, which lands in the python layout rows this plan
  declares; `out/run-user-git-diagrams.ps1` holds the user's `git mv` lines and is rewritten when that step is reached.
- ADR-AUTO-MODULE, ADR-DSGN-TRACK, ADR-DSGN-TRACKTYPE, ADR-DSGN-MODTYPE, ADR-AUTO-PY, ADR-AUTO-GO, ADR-AUTO-BASH, ADR-AUTO-EXTEND.
