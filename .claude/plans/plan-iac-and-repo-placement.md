---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [pwsh/Catzc.Base.Variants/configs/variants.yml, docs/adr/repository, docs/adr/azure]
---

# Where infrastructure lives, and what a repo is

The catzc tooling is a CLI that maps to file artifacts through tracks (semantic placements in a tree). This repo is a mono-repo, but the
tooling can be exported to other repos or used with no repo, so no placement is fixed: a track resolves it. Two questions follow: where
the infrastructure code lives (`.azure` as a vendor folder is a candidate), and which ADRs define what a repo is.

## Why its value is medium

Nothing is blocked today, but every exported bundle and every new vendor folder repeats the placement question until it is decided.

## Decided (2026-10-19, from the user)

- Placement varies from repo to repo; the tooling resolves it through tracks, never through a hardcoded path.
- `.azure` is considered as a vendor folder, like `.ado` (plan-ado-and-cicd-docs).
- The infrastructure code is three distinct things that may be placed differently: IaC modules (templates), IaC configs, IaC reusable
  modules.

## Open steps

- [ ] Decide the placement of the three IaC kinds: one vendor folder or separate places, and their names (check: the answer is recorded
      here, then written as a rule in `docs/adr/azure`).
- [ ] Write the ADR rules that define a repo: mono-repo, consumer repo, no repo, with `eac`'s docs as inspiration only (check: Test-Adr
      clean; the rules sit in `docs/adr/repository` and the index lists the codes).
- [ ] Record each IaC kind as a track place in `variants.yml` once decided (check: Test-Variants clean).

## Refs

- docs/adr/design/tracks.md (ADR-DSGN-TRACK); the bundle exporter note in memory (`Catzc.Base.Exporter`) for the anchor split.
