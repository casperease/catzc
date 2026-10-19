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

## Open steps

- [ ] L3: `pwsh/Catzc.Base.ModuleSystem/configs/importer.yml` with its `ImporterConfig` C# type (defaults on the type), and `Get-ImportMix`
      reporting the current truth, engines [pwsh], languages [powershell, csharp], modules = all in the root; L0 tests with neutral fixtures
      (check: `Invoke-TestFile` on the new test file passes in a fresh `pwsh`, since a C# type edit recompiles).
- [ ] L4: the `-Languages` and `-Engines` switches on the importer and module selection by language; the importer shim is generated, so its
      source is edited and regenerated (check: a module whose live languages are outside the mix is not loaded in an L0 test;
      Test-GeneratedFiles clean).
- [ ] L5: the entry files follow the mix (check: Test-GeneratedFiles proves `importer.sh` is generated only with a POSIX engine in the mix).
- [ ] The per-language facts the importer needs (`build`, `test`, `layout` handlers) go in `languages.yml` beside `formatter`, `checks` and
      `executable`; whether `FileLanguage` rejects unknown keys is checked first, and a new key edits the type before the config (check: the
      config loads in a fresh `pwsh`; the importer throws `NotImplemented` for a configured language without a handler).

## Refs

- docs/adr/automation/importer.md (ADR-AUTO-IMPORTER), docs/adr/automation/layers.md (ADR-AUTO-LAYERS-IMPORTERDECIDESMIX),
  docs/adr/automation/execution-engines.md (ADR-AUTO-ENGINE).
- The layer-model draft this came from is in git under `plan-layers-vocabulary-rename-contracts.md`.
