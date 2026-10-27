---
plan:
  status: active
  value: medium
  reviewed: 2026-10-27
  class: meta
  targets: [pwsh, contracts, go, python, js]
---

# catzc and cats usage: one name per role across code and yml

A map of every `catzc`/`cats` form in tracked code and yml (2026-10-27, about 15,850 hits in 11 categories) showed names that break
[PDR-CATS-CATZCISSOURCENAME](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename) and
[PDR-CATS-ISPERSONNAME](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-ispersonname): `cats` inside identifiers, and
catzc-prefixed names left over from old disk names, where the current folder drops the namespace. Live names stay: `Catzc.` namespaces,
`contracts/catzc/`, `.catzc`, extension ids, git attribute classes, temp prefixes, and the test fixtures that mirror them (`Catzc.Widget`,
`catzc-widget`, `CATZC_WIDGET_ROOT`).

## Open questions

- Should `docs/drs/principles/cats-and-catzc.md` carry a short table of the live catzc forms (namespace, `contracts/catzc/`, `.catzc`,
  `CATZC_` env vars, extension ids, git attribute classes, mirrored fixtures), so the next cleanup reads one table instead of re-mapping
  15,850 hits? Recommended: yes, one table on the rule page; it shrinks the next session's map to the forms that are not in it.

## Open steps

- [ ] `docs/references/pwsh/base-docs/index.md`: its Division row of the ask-cats responsibility names the retired command name; it becomes
      `Show-Catzc`, the one caller the rename left to the front-page owner of that article. Check: `Test-Links` and `Format-Code` pass on
      that article.
- [ ] `Catzc.Base.Overlay`: `Get-CatzcOverlay` → `Get-Overlay`, `Import-CatzcOverlay` → `Import-Overlay`, `Assert-CatzcOverlay` →
      `Assert-Overlay`; the overlay is the consumer's, and the module already qualifies it
      ([PDR-CATS-IDENTIFIERNAMESTHESYSTEM](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-identifiernamesthesystem)). Each
      function file, its test file and its `docs/references/pwsh/base-overlay/` page (and `tests/` page) take the new name; callers
      `pwsh/.internal/Catzc.Internal.Importer.psm1`, `pwsh/Base.QualityGates/configs/source-conventions.yml`,
      `docs/references/pwsh/base-overlay/index.md`, `private/get-local-module-violation.md`, `docs/drs/automation/consumer-overlay.md`. The
      new exported files land by staged burst. Check: `pwsh/Base.Overlay/tests/*.Tests.ps1` pass, then a fresh import.
- [ ] `Catzc.Base.Exporter`: `Get-CatzcContentHash` → `Get-ContentHash` (hashes any folder's content), private `Get-CatzcUserModulePath`
      → `Get-UserModulePath` (the user's own module path). Each function file, test file and `docs/references/pwsh/base-exporter/` page take
      the new name; callers `Install-Catzc.ps1`, `Assert-CatzcBundle.ps1` and their tests, `pwsh/.internal/Catzc.Internal.Builder.psm1`,
      `pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1`, `docs/references/pwsh/internal/catzc-internal-builder.md`,
      `docs/references/pwsh/base-exporter/index.md` and `assert-catzc-bundle.md`, `docs/drs/automation/platform-bundle.md`. The new exported
      file lands by staged burst. Check: `pwsh/Base.Exporter/tests/*.Tests.ps1` and `pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1`
      pass, then a fresh import.
- [ ] `Catzc.Base.Repository`: `Get-CatzcOverlayRoot` → `Get-OverlayRoot` (the consumer overlay root; `Get-ConfigOverlayRoot` stays
      distinct). Its file, test file and `docs/references/pwsh/base-repository/` page take the new name; callers `Get-CatzcModuleRoot.ps1`
      and its test, `Base.Overlay` (`Get-Overlay.ps1`, three tests, `Overlay.Fixture.ps1`), `Base.Config` (`Get-ConfigOverlayRoot.ps1`, its
      test and page), `pwsh/Base.QualityGates/configs/source-conventions.yml`, `docs/references/pwsh/base-repository/index.md`,
      `docs/drs/automation/consumer-overlay.md`. Every build-mode import calls it, so one burst lands the function and every caller. Check:
      `pwsh/Base.Repository/tests/*.Tests.ps1`, `pwsh/Base.Overlay/tests/*.Tests.ps1` and
      `pwsh/Base.Config/tests/Get-ConfigOverlayRoot.Tests.ps1` pass, then a fresh import.

None of the new names is a command in the tree, the vendored modules or pwsh itself, and each keeps the `Verb-Noun` case and file
round-trip that `Test-IdiomaticNames` checks.

## Names that keep catzc

| Names | Why the token stays |
| --- | --- |
| `Get-CatzcModulesRoot`, `Get-CatzcModulesFolder`, `CatzcModulesRoot`, `CatzcModulesFolder` | the system's modules root, not the repository root |
| `Get-CatzcModuleRoot`, `Get-ForeignCatzcModule` | named by the rule itself |
| `Get-CatzcModule`, `Get-CatzcModules`, `Copy-CatzcModule`, `$catzcModules`, `catzc_module` | the system's modules as against any loaded module |
| `Import-Catzc`, `Export-Catzc`, `Install-Catzc`, `Show-Catzc` | the noun is the system itself |
| `Invoke-CatzcCommand`, `Enter-CatzcBurst`, `Exit-CatzcBurst` | entry scripts run by path, with no module namespace |
| `Wait-CatzcRunLock` and its `*-CatzcRunLock*` helpers | the system's run lock `Local\catzc-run`, in a script with no module |
| `Get-CatzcRunMode`, `Assert-CatzcRunModeExclusive` | whether the system runs from source or a build |
| `Assert-CatzcBundle`, `Resolve-CatzcBuildVersion`, `New-CatzcNuGetPackage` | the system's bundle, its version and its package |
| `Format-CatzcPackageManifest`, `Test-CatzcBuild` | the `Catzc.psd1` manifest and the system's build |
| `New-BuiltCatzcRoot`, `Remove-BuiltCatzcRoot`, `Invoke-InBuiltCatzc` | a built copy of the system, as against the source tree |
| `Measure-CatzcRules`, `Measure-CatzcSpelling` and their modules | the system's analyzer rules beside PSScriptAnalyzer's |
| `CatzcMeta` | the `catzc` head block as an MSBuild property |
| `CatzcTypes*`, `CatzcAssets`, `CatzcSmaPath`, `Catzc*ExitCode` | the `Catzc.Types` build in MSBuild's flat property space |
| `CatzcFiles` | the system's key in a manifest's shared `PrivateData` |
| `$catzcModuleFile`, `$catzcParseErrors`, `$catzcModuleAst`, `$catzcFirstError` | the loader's variables inside every module's scope |
| `$CatzcChild*` | the TestKit runner's names in the scope the importer joins |
| `CatzcType` (`ContractParameter.cs`) | it matches `Catzc.*` type names |
| C# `Catzc.*` namespaces, `Catzc.` accelerators | [PDR-CATS-CATZCISSOURCENAME](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename) |
