# Add a language track

A language track holds the modules of one programming language the way `pwsh` holds the PowerShell ones: a root folder, modules by layout, a
test runner, and a place in `Test-Automation`. The rules are [module-model](../../../drs/automation/module-model.md) and
[tracks](../../../drs/design/tracks.md); the language's own decisions get a decision record under `docs/drs/automation/<language>/`, as
[javascript-track](../../../drs/automation/javascript/javascript-track.md) does for `js`. This page is the checklist: each touch point
below, in order, with the `js` track as the worked example.

## Declare the track

1. **The track** — a row in `pwsh/Base.Variants/configs/variants.yml` under `tracks:`: its members (the root folder), `type: modules`, the
   languages it holds, and its kinds
   (`js: { members: [js], type: modules, languages: [javascript, json, asset], kinds: { extensions: js } }`).
2. **The module type** — an entry in `pwsh/Base.Variants/configs/module-types.yml` that says how a module of the track is found under its
   root (for `js`, every folder under `js/` but `tests` is a module, named by its folder).
3. **The track type admits it** — add the module type to the `modules` type's `admits:` list in
   `pwsh/Base.Variants/configs/track-types.yml`.

## Declare the language

1. **The language row** — an entry in `pwsh/Base.Languages/configs/languages.yml` under `languages:`: its extensions, its naming (folder,
   file, function and type cases), its formatter, its checks, its test runner (`tests: { runner, pattern, tools }`), and its layout. Give it
   a `tag` if a diagram or a lamp should name it.
2. **The language config** — `pwsh/Base.Languages/configs/<language>.yml` with its config type in `types/` (for `js`, `javascript.yml` and
   `JavaScriptConfig`, which declares the root's default once: `js` when the folder exists, else `.js`), and its entry in
   `pwsh/Base.Config/configs/configs.yml`.

## Run its tests

1. **The runner** — `Invoke-<Language>Test` in `pwsh/Base.Languages/`, which locates the managed tool, runs one module's tests, and returns
   one result per case; its result type in `types/` (`JavaScriptTestResult`) and the parser of the tool's report in `private/`
   (`ConvertFrom-NodeTestJunit`).
2. **The case discovery** — `Get-<Language>TestCases` in `pwsh/Base.QualityGates/private/`, which lists a module's cases from its test files
   without running them, so `Test-Automation` can order, tier and filter them.
3. **The bridge branch** — one branch per language in `pwsh/Base.QualityGates/tests/Language.Bridge.ps1`: the discovery call, and which
   engine the cases run under.

Each of these pieces gets its own Pester test file, and the runner a test that runs a module named in the language's own case.

## Check it

```powershell
Invoke-<Language>Test <module>                    # one module's tests, one result per case
Test-Automation -Modules <module>                 # the same cases through the bridge
Test-Links -Path docs/drs/automation/<language>/  # the language's decision record
```
