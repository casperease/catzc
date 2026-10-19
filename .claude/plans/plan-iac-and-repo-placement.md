---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [pwsh/Catzc.Base.Variants/configs/variants.yml, infrastructure, docs/adr/repository, docs/adr/azure]
---

# Where infrastructure lives, and what a repo is

The catzc tooling is a CLI that maps to file artifacts through tracks (semantic placements in a tree). This repo is a mono-repo, but the
tooling can be exported to other repos or used with no repo, so no placement is fixed: a track resolves it. Two things follow: the
infrastructure code has three kinds that a track names, and ADRs define what a repo is.

## Why its value is medium

Nothing is blocked today, but every exported bundle repeats the placement question until the three kinds are named by the track and the repo
kinds are defined.

## Decided (2026-10-19, from the user)

- Placement varies from repo to repo; the tooling resolves it through tracks, never through a hardcoded path.
- The infrastructure stays in `infrastructure/`; the `.azure` vendor folder is dropped. Today `infrastructure/templates/<name>/` holds a
  template (`main.bicep`, `options.yml`) with its `configuration/` beside it, and `infrastructure/modules/` holds the reusable modules; the
  `infrastructure` track already declares both places with `vendor: azure`.
- The three kinds are named as track places, so any repo can map each one elsewhere: IaC templates, IaC configs, IaC reusable modules.

## Open steps

- [ ] Split the `infrastructure` track's places in `variants.yml` into the three named kinds (templates, configs, reusable modules), with
      the configs place covering each template's `configuration/` folder (check: Test-Variants clean; the track resolves the same files).
- [ ] Write the ADR rule that names the three IaC kinds and says a track, not a path, places them (check: Test-Adr clean; the rule sits in
      `docs/adr/azure` and the index lists the code).
- [ ] Write the ADR rules that define a repo: mono-repo, consumer repo, no repo, with `eac`'s docs as inspiration only (check: Test-Adr
      clean; the rules sit in `docs/adr/repository` and the index lists the codes).

## Refs

- docs/adr/design/tracks.md (ADR-DSGN-TRACK); the bundle exporter note in memory (`Catzc.Base.Exporter`) for the anchor split.
