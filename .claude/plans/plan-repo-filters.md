---
plan:
  status: active
  value: high
  reviewed: 2026-10-24
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1,
      pwsh/Catzc.Base.Globs/Get-AspectCover.ps1,
      pwsh/Catzc.Base.Config/configs/configs.yml,
      pwsh/Catzc.Base.VSCode/New-VsCodeSettings.ps1,
      pwsh/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1,
      pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml,
      pwsh/Catzc.Base.VSCode/assets/extensions/catzc-track-lamps.js,
      pwsh/Catzc.Base.VSCode/tests/catzc-track-lamps.Tests.ps1,
      .claude/plans/plan-track-model.md,
    ]
---

# Repository filters: named, overlapping views over the hard model, one lamp each

Two layers. The **hard model** is tracks and aspects: every file in exactly one track (or a root file), every unit's files split into
disjoint, exhaustive aspects, gated by `Test-TrackDeclaration`, the partition check and the world map; the globsets, identities, pipelines
and bundles rest on it. A **filter** is a named view over that model: a union of globsets written in a small in-repo syntax, its contents
free to **overlap** another filter's; some filters are backed by a hard rule (`code` is the live aspect) and may still hold generated or
vendor files. Filters shrink the repository for a reader; the editor's lamps are one renderer, a pwsh query the other, both reading the one
declaration.

## Why its value is high

The lamps work and the user uses them; today their sets are hard-coded in the extension and partly re-derived beside the aspect model
(`Get-AspectCover` builds its own units), which is a second version of the aspects (PDR-ONELIVE). One declaration of named filters, read by
one resolver, makes every new view a config line, and moving the extra units into the aspect model gates them and lets bundles use them.

## Decided (the user, 2026-10-24)

- Filters overlap; tracks and aspects never do. A filter never redefines a track or an aspect; it only selects them.
- Filters are declared once, `filters.yml` (`Catzc.Base.Globs`, a `FiltersConfig` type), each a name and its selectors, in declaration
  order. Selectors in the dotted snake normal form, a prefix selecting everything below it: `aspect.<name>`, `track.<name>`,
  `track_type.<type>`, `generated`, `root_config`, and `glob.<pattern>` as the escape hatch.
- The filters: `code` (`aspect.live`), `tests` (`aspect.tests`), `tools` (`track_type.vendor_settings`, `track_type.vendored_code`,
  `track_type.pipelines`, `root_config`), `generated` (`generated`), `docs` (`track.docs`, `glob.LICENSE`), `out` (`glob.out/**` until `out`
  is a track). No `contracts` filter: the contracts track declares its aspects in `variants.yml` as `infrastructure` does (`tests`
  `**/tests/**`, then `live` `**`, DDR-ASPECT-TRACKPICKSCATCHALL), so its contract files are live and `code` shows them.
- `LICENSE` is authored, not generated (no generator or `rootconfig.yml` target writes it); it is docs (the `docs` filter) and live through
  the contracts track, which it joins in `plan-track-model.md`.
- Combination is **hide wins**: a file shows only while every filter that claims it is lit, so putting a lamp out never reveals a file and
  `generated` hiding inside a lit `code` needs no special case.
- Coverage is asserted: every file on disk is claimed by at least one filter. The census counts files per membership signature (the set of
  filters claiming a file: `{code}`, `{code, generated}`, …) and shows that matrix in the counter's tooltip.
- The tool caches (`.ruff_cache`, `.pytest_cache`, `python/.ruff_cache`) are generated, declared by the Python tooling's `generated.yml`.
- The extra live units are the aspect model's, never the filter's: the python, go and bash modules, `.internal` (its single-file modules
  live, the rest by the code convention) and `.scriptanalyzer` get aspect sets in `Get-ModuleGlobSet`, gated by the partition check;
  `Get-AspectCover` only folds those sets and builds no unit of its own.
- The lamps are generic: one per declared filter, its icons `<filter>-on.svg` / `<filter>-off.svg`, the manifest's lamp commands checked
  against `filters.yml` by a test. Paths compare case-insensitively on Windows, as the file system does.

## Open steps

1. [ ] `pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1`: aspect sets for every laid-out track's modules (python, go, bash), the single-file
       internal modules (live), the `.internal` and `.scriptanalyzer` folders by the code convention (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1`, and the partition check over `git ls-files` passes).
2. [ ] `pwsh/Catzc.Base.Globs/Get-AspectCover.ps1`: fold only `Get-ModuleGlobSet`'s aspect sets and the declared tracks', its own unit
       derivation deleted (check: `Invoke-TestFile -Path pwsh/Catzc.Base.Globs/tests/Get-AspectCover.Tests.ps1`).
3. [ ] `pwsh/Catzc.Base.Globs/types/FiltersConfig.cs` (new) and `pwsh/Catzc.Base.Config/configs/configs.yml`: the `filters` config, name to
       selectors, every selector parsed and refused when unknown (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Globs/tests/types/FiltersConfig.Tests.ps1`).
4. [ ] `pwsh/Catzc.Base.Globs/Get-RepositoryFilter.ps1` (new) with `pwsh/Catzc.Base.Globs/configs/filters.yml`: each filter resolved to its
       paths and globs from the selectors (check: `Invoke-TestFile -Path pwsh/Catzc.Base.Globs/tests/Get-RepositoryFilter.Tests.ps1`, an L1
       case that every file on disk is claimed by a filter).
5. [ ] `pwsh/Catzc.Tooling.Python/configs/generated.yml` (new): the ruff and pytest caches (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Variants/tests/Get-GeneratedTarget.Tests.ps1`).
6. [ ] `pwsh/Catzc.Base.VSCode/New-VsCodeSettings.ps1` and `pwsh/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1`: the settings
       carry `catzc.trackLamps.filters` (filter to paths and globs, in order) in place of the aspects, tools and generated keys (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.VSCode/tests/New-VsCodeSettings.Tests.ps1`).
7. [ ] `pwsh/Catzc.Base.VSCode/assets/extensions/catzc-track-lamps.js`: lamps from the rendered filters, hide wins, the census by membership
       signature with the coverage assert, case-insensitive paths on Windows; the generated special case and `rest` deleted (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.VSCode/tests/catzc-track-lamps.Tests.ps1`).
8. [ ] `pwsh/Catzc.Base.VSCode/configs/vscode-extensions.yml`: a lamp command pair per filter with `docs` and `out` icons, a test that the
       manifest's lamps are exactly `filters.yml`'s names (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.VSCode/tests/catzc-track-lamps.Tests.ps1`; the user reloads and looks).
9. [ ] `.claude/plans/plan-track-model.md`: its lamp decisions and lamp step removed, this plan owning them (check:
       `Test-Plans -Path .claude/plans/plan-track-model.md`).

## Refs

- DDR-TRACK, DDR-ASPECT, PDR-ONELIVE, PDR-CONFIG, ADR-AUTO-IDIOM-NORMALFORM.
