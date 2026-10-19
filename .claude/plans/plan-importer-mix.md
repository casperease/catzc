---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [pwsh/Catzc.Base.ModuleSystem, importer.ps1, docs/adr/automation/importer.md]
---

# The importer decides the mix of languages, engines and modules

ADR-AUTO-IMPORTER states the rules (DECIDESMIX, ONEMIXRECORD, UNHANDLEDLANGUAGESTOPS, MODEANDHOSTORTHOGONAL) and nothing implements them:
there is no `ImporterConfig`, no `importer.yml`, no `Get-ImportMix`. This plan builds the mix smallest first, report-only before any effect.

## Why its value is medium

Nothing is blocked today: one engine and two languages are the whole mix. The value is that the test runner and the builder read one record
instead of each re-deciding, and that a second engine or language has one place to enter.

## Decided (2026-10-16 as the layer model's L3 to L5; 2026-10-19 the user made it this plan)

- Inputs follow ADR-AUTO-DEFAULT-ONERESOLUTIONORDER: the caller's `-Languages` and `-Engines` importer switches, else `importer.yml` in
  `pwsh/Catzc.Base.ModuleSystem/configs/`, else the defaults declared once on the `ImporterConfig` type; environment variables only where
  ADR-AUTO-ENVVAR allows an external contract.
- Values: `auto` (default) or an explicit list. `auto` for engines is pwsh plus every POSIX engine whose executable exists (a missing zsh is
  skipped and reported); `auto` for languages is the executable languages of the loaded modules.
- Result: one `ImportMix { Languages, Engines, Modules }` record for the session, read by `Get-ImportMix`; the test runner reads engines
  from it, the builder reads modules.
- Effects in cost order: report only; module selection by language; entry files follow the mix (`importer.sh` only when a POSIX engine is in
  the mix); languages beyond powershell and csharp throw `NotImplemented` when configured.
- `ExecutionEngines` stays a compiled C# model (closed set); languages stay config; no regrouping of AUTO files by layer; the concern
  `automation` keeps its name.
- `importer` is registered in `Catzc.Base.Config/configs/configs.yml` as `Catzc.Base.ModuleSystem.ImporterConfig`, overridable (a consumer
  may choose its own mix). Decided by the orchestrator on the user's delegation, 2026-10-19.
- The resolution is one pure C# function, `ImportMix.Resolve`, fed the session's facts (located engines, module languages, the languages
  configuration), so L0 tests cover it with neutral fixtures. An explicit engine whose executable is absent stops the resolution, because
  only `auto` skips and reports. Recommended by catzc-08, 2026-10-19.
- `auto` reports the truth of the tree, not a fixed list: engines [pwsh, bash] with zsh skipped on this devbox, and languages [powershell,
  csharp], the code languages of the modules (the `.sh` files in assets do not count). Recorded by catzc-08, 2026-10-19.
- L4, decided by the orchestrator on the user's delegation, 2026-10-19, as ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD and
  ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES:
  - `Invoke-Importer` loads every module, resolves the mix once (`Set-ImportMix`), keeps it as the session record `Get-ImportMix` returns,
    then removes the modules outside the mix. The reason: the decision reads the module model, the languages configuration and the engine
    locator as every command does.
  - A module's code languages are the executable languages of its files outside `assets/` and `tests/`, read from the layout model (a
    language's own rows, never the shared ones); a module with one outside the mix is not loaded. The reason: assets are shipped data and
    tests run under the test runner. Named "code", not "live", because the module model's live files include assets
    (ADR-AUTO-MODULE-EXISTSBYLAYOUT).
  - Rejected (b), a two-phase load (deciding modules first, the rest filtered): it carries a second load path.
  - Rejected (c), an extension-to-language map in `.internal`: it is a second living version of `languages.yml`.
- A console import with no `-Languages` or `-Engines` resolves the mix at the first prompt, before the deferred janitors, so the console
  import stays types-free. A headless host, or a caller that passes an axis, resolves it inline. A toolset without `Catzc.Base.ModuleSystem`
  stops when it is given an axis. Recommended by catzc-08, 2026-10-19.
- L5, decided by the orchestrator on the user's delegation, 2026-10-19, as ADR-AUTO-IMPORTER-ENTRIESFOLLOWMIX: `Get-RootConfigTargets`
  leaves out an entry that is an engine's `ImporterEntry` when none of the engines it serves is in the mix. The reason: the engine model
  already names each engine's entry. Rejected: an `engines:` key on the `rootconfig.yml` entry, which would be a second copy of that fact.
- Committed generated files read the mix-independent opted-in list: `Get-RootConfigTargets -FollowMix` (off by default) is passed only by
  `Build-RootConfig`, where a file is materialised; `Invoke-RootConfigGenerator` and `Test-RootConfigFiles` keep the plain list. The reason:
  a committed file must not change with a session's mix. Rejected: accepting a stale `.vscode/settings.json` in a pwsh-only session as an
  edge case. Decided by the orchestrator on the user's delegation, 2026-10-19.
- The per-language facts the importer needs are in `languages.yml`: `layout` (with `shipped`, what the builder reads) and `tests` (the
  runner). So no key is added, and `FileLanguage.handled` is derived: an executable language with layout rows or a tests runner. That is
  powershell, csharp, python, go and bash, the list ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS names. `LanguagesConfig.AllowedEntryKeys` is
  unchanged. `Resolve-ImportMix` rethrows the resolution's own exception, so the importer stops with `NotImplementedException`, not its call
  wrapper. Recommended by catzc-08, 2026-10-19.

## Open steps

- [x] L3: `importer.yml`, `ImporterConfig`, `ImportMix` and `Get-ImportMix`, with L0 tests — verdict: `Invoke-TestFile` Passed for
      `ImporterConfig.Tests.ps1`, `ImportMix.Tests.ps1`, `Get-ImportMix.Tests.ps1` and `Catzc.Base.Config/tests/Get-Config.Tests.ps1` in a
      fresh `pwsh`; `Get-Config -Config importer` is an `ImporterConfig`.
- [x] L4: `-Languages`/`-Engines` on the importer, `Set-ImportMix` and `Resolve-ImportMix`, `importer.ps1` regenerated — verdict:
      `Invoke-TestFile` Passed for the ImporterConfig, ImportMix, Resolve-ImportMix, Get-ImportMix, Set-ImportMix and New-Importer test
      files in a fresh `pwsh` (`Set-ImportMix.Tests.ps1` proves a module with a code language outside the mix is removed);
      `Test-GeneratedFiles -Generator New-Importer` found no issues; headless import 2.8 s, live mix languages [powershell, csharp], no
      module skipped.
- [x] L5: `Get-RootConfigTargets` drops an engine's importer entry outside the mix — verdict: `Get-RootConfigTargets.Tests.ps1` Passed (mix
      [pwsh] leaves out `importer.sh`, [pwsh, bash] keeps it); in a fresh `pwsh`, the default mix manages `importer.ps1, importer.sh` with
      Test-GeneratedFiles at 0 issues, and `-Engines pwsh` manages `importer.ps1` only; Test-ModuleDependency and Test-ModuleCycles at 0
      issues; full `. ./importer.ps1` with janitors loads.
- [x] `.vscode/settings.json` no longer follows the mix — verdict: in a fresh `pwsh` imported with `-Engines pwsh`, Test-GeneratedFiles no
      longer reports `.vscode/settings.json`; its three remaining issues (`.cspell/adr-codes.txt`, `.markdownlint.yml`, `.prettierrc.yml`)
      come from peers' staged edits under `RootConfig/assets/root` and the ADO recode, not the mix; `Get-RootConfigTargets.Tests.ps1` covers
      both switch states.
- [x] The per-language handler facts, derived as `FileLanguage.handled` from the `layout` and `tests` keys already in `languages.yml` —
      verdict: in a fresh `pwsh`, `Get-Config -Config languages` loads as `LanguagesConfig` with handled [powershell, csharp, python, go,
      bash]; `. ./importer.ps1 -Languages yaml` throws
      `System.NotImplementedException: The mix names the language 'yaml', which the importer has no     handler for`; `Invoke-TestFile`
      Passed for the ImportMix, Resolve-ImportMix, Set-ImportMix, Get-RootConfigTargets and Get-FileLanguage test files.

## Refs

- docs/adr/automation/importer.md (ADR-AUTO-IMPORTER), docs/adr/automation/layers.md (ADR-AUTO-LAYERS-IMPORTERDECIDESMIX),
  docs/adr/automation/execution-engines.md (ADR-AUTO-ENGINE).
- The layer-model draft this came from is in git under `plan-layers-vocabulary-rename-contracts.md`.
