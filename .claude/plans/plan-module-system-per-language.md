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

## Open steps

- [ ] `pwsh/Catzc.Base.Variants/types/ModulePlace.cs`: a folder place takes `except`, the folder names under its root that are the track's
      own and never a module; `NameOf` returns null for them (check: `ModuleTypesConfig.Tests.ps1` gains a case where `widgetry/tests/x`
      resolves to the root place's module and `widgetry/gadget/x` to `Gadget`).
- [ ] `pwsh/Catzc.Base.Variants/types/ModuleTypesConfig.cs`: reads `except` on a folder place, a list of folder names, refused on a file or
      root place (check: the same test file, an `except` on a root place is an error naming the place).
- [ ] `pwsh/Catzc.Base.Variants/configs/module-types.yml`: `python`, `go` and `bash` each get
      `{ root: <root>, name: folder, except: [tests] }` ahead of their root place, definitions reworded to "a module of the language's
      track, a folder under the track folder named by the folder; the track's own files are the track's module" (check:
      `Get-PathModule.Tests.ps1` resolves `python/tests/catzc-base-repository/test_repository.py` to `python` still and
      `python/Widget.Gadget/gadget.py` to `Widget.Gadget`).
- [ ] `pwsh/Catzc.Base.Variants/configs/track-types.yml`: `modules` reads "Deployable modules of a language track, collected into the
      bundles `files.yml` declares" and admits `pwsh-folder`, `pwsh-psm1`, `python`, `go`, `bash`; `verification` is removed (check:
      `Test-TrackDeclaration.Tests.ps1` and `TrackTypesConfig.Tests.ps1` pass).
- [ ] `pwsh/Catzc.Base.Variants/configs/variants.yml`: `python`, `go` and `bash` tracks are `type: modules` (check: `Test-TrackDeclaration`
      on the config passes; `Get-Track python` reports `modules`).
- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: layout rows for python (`.py` at the root, role `script`), go (`.go`, role
      `source`) and bash (`.sh`, role `script`); each language's `tests` entry gains `pattern` (`test_*.py`, `*_test.go`, `*.bats`) (check:
      `LanguagesConfig.Tests.ps1` passes; `Get-FileLanguage.Tests.ps1:85` no longer names `verification`).
- [ ] `pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs`: `pattern` is a key of `tests`, required when `runner` is given (check: the types
      test for a `tests` entry without `pattern` names the language).
- [ ] `pwsh/Catzc.Base.Modules/Get-CatzcModule.ps1`: the anchor is the track whose place is the catzc modules folder, not the `modules` id;
      a root place's module holds only the files no folder place of the same track names (check: `Get-CatzcModule.Tests.ps1` gains a fixture
      track with a folder place and a root place where every file lands in exactly one module).
- [ ] `pwsh/Catzc.Base.Modules/Get-Aspect.ps1`: the laid-out check (the track's primary language owns layout rows) replaces the `modules` id
      (check: `Get-Aspect.Tests.ps1` passes with a laid-out fixture track of another type name).
- [ ] `pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1`: the languages are those of the registry with a `tests` runner,
      each root from `Get-Config -Config <language>` and each pattern from the registry; a module's own `tests/` under a language track
      yields a record for that module (check: `Get-LanguageTestFolders.Tests.ps1` passes with a fixture language and a module-own folder).
- [ ] `pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1`: runs the folder the record names, the holder's `tests/<kebab>` or a module's own
      `tests/` (check: `Invoke-PythonTest.Tests.ps1` covers both folders).
- [ ] `pwsh/Catzc.Base.Languages/Invoke-GoTest.ps1`: the same two folder shapes (check: `Invoke-GoTest.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Languages/Invoke-BashTest.ps1`: the same two folder shapes (check: `Invoke-BashTest.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Languages/New-PythonProject.ps1`: every module folder under the Python root is a workspace member beside `tests/*`,
      each with its generated member `pyproject.toml`; `extra_paths` goes (check: `New-PythonProject.Tests.ps1` renders a member for a
      fixture module folder; the rendered root names no `extraPaths`).
- [ ] `pwsh/Catzc.Base.Languages/types/PythonConfig.cs`: `extra_paths` removed from the keys and the type (check: `PythonConfig.Tests.ps1`;
      `git grep extra_paths` finds nothing).
- [ ] `pwsh/Catzc.Base.Languages/configs/python.yml`: the `extra_paths` block removed (check: `Build-RootConfig` regenerates
      `python/pyproject.toml` without `extraPaths`; `Test-GeneratedFiles` on it passes).
- [ ] `pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1`: every module folder under the Go root is a `go.work` member beside `tests/*` (check:
      `New-GoWorkspace.Tests.ps1` renders a member for a fixture module folder).
- [ ] `pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs`: `NeverLiveTypes` keeps `vendored-code` only; a test file is never live by the layout
      (check: `WorldMapBuilder.Tests.ps1` passes; the world map of the tree lights no python cell as live).
- [ ] `pwsh/Catzc.Base.Exporter/Assert-CatzcBundle.ps1`: the comment at line 37 names the layout, not the verification type (check:
      `Assert-CatzcBundle.Tests.ps1` passes).
- [ ] `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml`: "verification track" retires; "language track" enters, defined by the new rule
      (check: `Test-Glossary` clean; `Build-Glossary` run).
- [ ] `docs/adr/automation/module-model.md`: new rule ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE: a language track holds its modules as folders
      under its root, its own test holder under `<root>/tests/<kebab>` declared `except` on the place, a module's own tests under its
      `tests/`; nothing branches on a language or a type id; a new language is registry entries and one config (check: `Test-Adr` on the
      file; the index lists the code).
- [ ] `docs/adr/design/track-types.md`: ADR-DSGN-TRACKTYPE-CLOSEDSETOFTYPES drops `verification`, the `modules` definition reads as the
      registry's (check: `Test-Adr`, `Test-Links` on the file).
- [ ] `docs/adr/design/module-types.md`: ADR-DSGN-MODTYPE-TRACKTYPEADMITSMODULETYPES lists the new admits;
      ADR-DSGN-MODTYPE-DEPLOYABLEORHOLDERMODULE says a language track's own module is the track's name (check: `Test-Adr`, `Test-Links`).
- [ ] `docs/adr/automation/python/python-test-artifacts.md`: ADR-AUTO-PY-TESTARTIFACTSONLY retires; ADR-AUTO-PY-MODULESBYLAYOUT takes its
      place: a Python module exists by layout under the python track, ships only what `files.yml` packages, and the black-box tests keep
      their holder; the `.claude/` carve-out goes (check: `Test-Adr`; `Update-AdrCitation` re-cites the retired code; the index lists the
      new one).
- [ ] `docs/adr/automation/go/go-test-artifacts.md`: ADR-AUTO-GO-TESTARTIFACTSONLY retires for ADR-AUTO-GO-MODULESBYLAYOUT, the same shape
      (check: `Test-Adr`; `Update-AdrCitation`).
- [ ] `docs/adr/automation/bash/bash-test-artifacts.md`: ADR-AUTO-BASH-TESTARTIFACTSONLY retires for ADR-AUTO-BASH-MODULESBYLAYOUT (check:
      `Test-Adr`; `Update-AdrCitation`).
- [ ] The heads of the tracked files of the three tracks (`python/tests/**`, `go/**`, `bash/**`) carry `tracktype: modules` after
      `Sync-FileMeta` over those paths, one track at a time (check: `Test-FileMeta` on each track's paths passes).
- [ ] `pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1`: the extension proof: a third fixture language with a module type, a folder
      place with `except`, and one layout row resolves modules with no code change (check: the test passes; it is the javascript rehearsal).

## Refs

- `plan-diagram-engine`: its first step moves `.claude/drawio` to `python/Catzc.Diagrams`, which lands in the python layout rows this plan
  declares; `out/run-user-git-diagrams.ps1` holds the user's `git mv` lines and is rewritten when that step is reached.
- ADR-AUTO-MODULE, ADR-DSGN-TRACK, ADR-DSGN-TRACKTYPE, ADR-DSGN-MODTYPE, ADR-AUTO-PY, ADR-AUTO-GO, ADR-AUTO-BASH, ADR-AUTO-EXTEND.
