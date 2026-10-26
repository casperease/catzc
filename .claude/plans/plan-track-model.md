---
plan:
  status: active
  value: high
  reviewed: 2026-10-24
  class: feature
  targets:
    [
      docs/drs/design/tracks.md,
      docs/drs/design/track-types.md,
      docs/drs/flow/durable-sha-globs.md,
      pwsh/Catzc.Base.Variants/configs/track-types.yml,
      pwsh/Catzc.Base.Variants/configs/variants.yml,
      pwsh/Catzc.Base.Variants/types/VariantTrack.cs,
      pwsh/Catzc.Base.Variants/Get-Track.ps1,
      pwsh/Catzc.Base.Variants/Test-TrackDeclaration.ps1,
      pwsh/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1,
      pwsh/Catzc.Base.Globs/configs/globs/globs.yml,
      pwsh/Catzc.Base.Globs/Build-TrackGlobSets.ps1,
    ]
---

# The track model: members with facts, globsets derived from tracks

Three levels, each reading the one below. The **data model** (`variants.yml`, `VariantTrack.cs`): a track is a set of **members**, each a
folder, a file or a glob, and each member carries two facts, **generated** and **committed** (git tracks it, or it is gitignored). The
**globsets** are derived from the tracks: a buildable track's globset starts its pipeline, a vendor track's globset classifies and filters
and starts none. The repository filters and the editor's lamps over them are `plan-repo-filters.md`'s.

Today a track is a list of folder places, generated content has no fact of its own (only the targets of `rootconfig.yml` and the
hand-written shapes of `Get-AutoControlledGlobs`), the root holds vendor files no track names, `out/` is in none, and `globs.yml` repeats
each track's paths by hand: a regeneration of `infrastructure/README.md` starts `ci-infrastructure`.

## Why its value is high

"What is in a track, which of it is generated, which does git track" becomes one computed answer, read from one declaration, so a filter, a
gate, a trigger and the lamps all ask the same model; a generated file stops being a false pipeline trigger; every file on disk at the root
has a track.

## Decided (the user, 2026-10-24)

- A track's places become **members**; a member is a path or a glob with `generated` and `committed`. `VariantTrack.places` stays as the
  computed list of member paths for the callers that need only paths, never as a second declaration.
- `generated` is a member fact, never a track: `importer.ps1` is generated and belongs to `pwsh`. A member a catzc generator writes takes
  `generated` from that generator's declaration (`rootconfig.yml` and the other generators' targets, through `Get-GeneratedTarget`); a
  member only a vendor tool writes (`.ruff_cache`, `out`) declares it on the member; both at once is a load failure.
- `committed` is declared on the member and checked against the git index by `Test-TrackDeclaration`.
- A **vendor** is a tool, core, plugin or external dependency vendored into the repository, named by the tool (a short form is fine). Every
  `.vendor` folder and every vendor's settings sit under the one vendor umbrella, because vendoring is how HEAD stays reproducible and
  atomic through BVT. This replaces the "platform that reads a track's files" meaning of DDR-TRACKTYPE-OPTIONALVENDOR and its glossary
  entry, and it gets its own design record.
- A track's **name** is its definitive name in `variants.yml`, in the repository normal form (ADR-AUTO-IDIOM-NORMALFORM): `snake` segments,
  `.` for each level, the minimal path. A vendor's track always starts with the vendor: `vendor_<tool>[.<part>]`, e.g.
  `vendor_git.root_configs` (`.github`, `.gitattributes`, `.gitignore`), `vendor_azure.bicep`, `vendor_ai.claude`, `vendor_ado.pipelines`.
  The name is computed from the members' repository paths; the rule for the tail and for the tracks that are not a vendor's is still to be
  read from the user's examples.
- The **catch-up tracks**, all vendor tracks: `vendor_git.root_configs` above, and the editorconfig (`.editorconfig`), markdownlint
  (`.markdownlint.yml`, `.markdownlintignore`), prettier (`.prettierrc.yml`, `.prettierignore`), dotnet (`catzc.sln`,
  `Directory.Build.props`, `dotnet-tools.json`) and nuget (`nuget.config`) tracks, their names in the same form. `out` is its own track of a
  new type `output` (holder), covering all of `out/`, generated and gitignored.
- Root files join their tracks: `importer.ps1` and `PSScriptAnalyzerSettings.psd1` join `pwsh`, `importer.sh` joins `bash`, `go.work` joins
  `go`, `cspell.yml` joins `.cspell`, and `.ruff_cache` joins `python` (generated, gitignored by the tool's own `.gitignore`). `LICENSE`
  joins the `contracts` track (the user, 2026-10-24): it is authored, not generated, and belongs to the contracts category, live through the
  contracts track's aspects (plan-repo-filters); no root file is left without a track.
- A buildable track's globset (deployable role) is derived from its members and excludes its generated members; a vendor track's globset
  starts no pipeline. `globs.yml` keeps only the globsets that are not a whole track (deployable-units, slices).
- The ADRs carry no minimap and no lamp: they keep the general reasoning only. A **projection** (a minimap, an editor filter) is a view
  computed by a `Get-*` command over the generated truths, never drawn or stored by hand; what a minimap or a lamp is lives in the docs of
  the tool that draws it, never in a rule.

## Open steps

1. [ ] `docs/drs/design/track-types.md` (the user names three or four real paths and their track names first): the naming rule of a track in
       ADR-AUTO-IDIOM terms, `vendor_<tool>[.<part>]` for a vendor's track and the tail computed from the members' paths, written where the
       examples settle it (check: every track name the user gave is what the rule computes, read by hand against the examples).
2. [ ] `docs/drs/design/tracks.md`, DDR-TRACK-TRACKISPLACEDCLUSTER: replace "per DDR-TRACKTYPE naming (pending)" with the naming rule once
       step 1 lands (check: `Test-Links -Path docs/drs/design/tracks.md`).
3. [ ] `pwsh/Catzc.Base.Variants/configs/track-types.yml`: every vendor named by its tool, once step 1 settles the names (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Variants/tests/types/TrackTypesConfig.Tests.ps1`).
4. [ ] `pwsh/Catzc.Base.Variants/types/VariantsConfig.cs`: the track name checked in the normal form through
       `Catzc.Base.Objects.NameCase.IsNormal` once step 1 lands (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`).
5. [ ] `pwsh/Catzc.Base.Variants/configs/variants.yml`: every track renamed to its normal-form name, the catch-up tracks, `out`, and the
       root files moved into their tracks; every caller of an old track name changed in the same pass (check: `Test-TrackDeclaration`, and
       `Get-Track -Path` answers `vendor_git.root_configs` for `.gitignore`).
6. [ ] `pwsh/Catzc.Base.QualityGates/Test-TrackMemberCommitted.ps1`, the gate that reads the members against the git index and the disk (it
       sits above Catzc.Base.Variants, which cannot reach the git readers without a cycle): `generated` is declared in one place only (a
       member a catzc generator writes takes it from `Get-GeneratedTarget`, both at once an issue), and every root entry on disk lies in a
       track, `LICENSE` in `contracts` (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.QualityGates/tests/Test-TrackMemberCommitted.Tests.ps1`).
7. [ ] `pwsh/Catzc.Base.Git/private/Get-AutoControlledGlobs.ps1`: `out` and `out/*` come from the out track's gitignored member once step 5
       declares it, and their hand-written lines are deleted (check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Git/tests/Get-AutoControlledGlobs.Tests.ps1`).

## Refs

- DDR-TRACK, DDR-TRACKTYPE, FDR-CD-GLOBS, ADR-AUTO-IDIOM-NORMALFORM, PDR-CONFIG, PDR-ONELIVE.
- The normal form in code: `Catzc.Base.Objects.NameCase` (`ToNormal`, `FromNormal`, `IsNormal`), `ConvertTo-NormalName` and
  `ConvertFrom-NormalName` (`Catzc.Base.Languages`), `python/catzc_diagrams/normal_form.py`; paths through `RepoRelativePath`. The minimap's
  place rows (ADR-AUTO-IDIOM-PLACENORMALFORM, `Get-PlaceRow`) are a display form, not a track name.
