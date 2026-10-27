---
plan:
  status: active
  value: high
  reviewed: 2026-10-24
  class: feature
  targets: [js/track-lamps]
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
  is a track). The contracts track is live by its own aspects in `variants.yml` (`tests` `**/tests/**`, then `live` `**`,
  DDR-ASPECT-TRACKPICKSCATCHALL) and its files have one lamp, `contracts` (the user, 2026-10-25): `code` and `live` leave them out
  (`except: [track.contracts]`), apart from every other track's live files.
- `LICENSE` is authored, not generated (no generator or `rootconfig.yml` target writes it); it is docs (the `docs` filter) and live through
  the contracts track, which it is a member of.
- Combination is the **union** of the lit lamps: a file shows while at least one lit filter claims it, so putting a lamp out hides only what
  no other lit lamp claims (DDR-FILTER-TOTALUNION).
- Coverage is asserted: every file on disk is claimed by at least one filter. The census counts files per membership signature (the set of
  filters claiming a file: `{code}`, `{code, generated}`, …) and shows that matrix in the counter's tooltip.
- The tool caches and environments (`**/.ruff_cache`, `python/.venv`, `python/uv.lock`) are generated, declared by the Python tooling's
  `generated.yml`.
- The extra live units are the aspect model's, never the filter's: the python folder modules, `.internal` and `.scriptanalyzer` (their root
  `.psm1` files live, a single-file module keeping its own set) get aspect sets in `Get-ModuleGlobSet`, gated by `Test-GlobSetIndependence`;
  the go, bash and python root holders get none, their black-box tests already the tested module's.
- A filter carries the model's **sets**, never a list of files: each is `{ include, exclude }`, an aspect's straight from
  `Get-AspectGlobSet`, a path as itself and what lies under it. The extension classifies every file on disk by those patterns, so a new file
  is classified the moment it exists, and computes the entries it writes from one walk.
- The lamps are generic: one per declared filter, its icons `<filter>-<on|off>[-<condition>].svg`, the manifest's lamp commands repeated
  from `filters.yml` by the folder generator. Paths compare case-insensitively on Windows, as the file system does.

- A lamp is a **tri-state toggle** (DDR-FILTER-TOTALUNION): one click steps it round **off → on → veto → off**, and a vetoed lamp hides its
  whole zone even where a lit lamp claims it; its icon is `<filter>-veto.svg`.

## Decided (the user, 2026-10-25)

- The pipeline tracks (`ado-pipelines` at `.ado/pipelines`, `github-workflows` at `.github/workflows`, both of track type `pipelines`) leave
  the `tools` filter and get a filter lamp of their own, `pipelines` (`track_type.pipelines`), with a new pipeline icon. They are vendor
  files and also the fixtures of the repository's own pipelines and workflows, the local pipeline tracks. The rest of the vendor files stay
  in `tools`.
- The pipeline tracks are live, as `infrastructure` is: they declare aspects in `variants.yml` (`tests` `**/tests/**`, then `live` `**`), so
  `code` shows them as well as the `pipelines` lamp (filters overlap).
- `infrastructure` stays live and also gets a filter lamp of its own, `infrastructure` (`track.infrastructure`), with a factory icon.
- The live aspect splits in two lamps (the user, 2026-10-25): `code`, its executable part (`extensions:` narrows the aspect's sets to the
  code extensions), and `live`, all of it; a filter's `except:` leaves out what other selectors claim.
- The configuration part of everything as code gets a lamp of its own, `configs` (`kind.config`, the `config` file kind of `file-kinds.yml`:
  a module's `configs/*.yml`, a template's per-environment `configuration/**`), live as before, placed right after `code` and before
  `tests`; the lamp row reads open, code, configs, tests, tools, pipelines, infrastructure, generated, docs, out, languages. A `kind.<role>`
  selector resolves any declared file kind, its subkinds included.
- A track's files are its places minus the places of the tracks nested inside it (`.github` without `.github/workflows`, `pwsh` without
  `pwsh/.vendor`): every file is in exactly one track, so a track selector in a filter says the same.

- Empty-on-disk folders show instead of being hidden while a lamp is off (the user, 2026-10-25; DDR-FILTER-EVERYFILECLAIMED): the hide-empty
  branch of the extension goes.

## Open steps

1. [ ] Reload VS Code (`catzc-track-lamps` 0.26.0 is installed). Check: the counter reads "everything is accounted for" with each lamp
       off in turn, and a vetoed lamp shows no staged, unstaged or failed condition colour; the user looks, each remark landing here as its
       own step.

## Refs

- DDR-TRACK, DDR-ASPECT, PDR-ONELIVE, PDR-CONFIG, ADR-AUTO-IDIOM-NORMALFORM.
