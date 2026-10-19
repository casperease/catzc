---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets: [pipelines, pwsh/Catzc.Base.Variants/configs/variants.yml, docs/adr/flow, docs/adr/pipelines]
---

# Move the ado pipelines into `.ado` and separate them from the CI/CD pipeline concept

The root `pipelines/` folder is the azure devops pipelines vendor tree. It moves as-is into `.ado/pipelines/` (so `.ado/pipelines/extends`
and the rest keep their structure), and the documentation separates two concepts: the azure devops pipelines (always written "azure devops
pipelines" or "ado pipelines") and the generalized CI/CD pipelines concept. The repo also gets proper CI/CD documentation in ADR-FLOW.

## Why its value is high

Every ADR and article that says "pipeline" mixes the ado variant with the concept, and the vendor folder sits at the root with no vendor
marker, unlike the other vendor folders.

## Decided (2026-10-19, from the user)

- The move is a plain move: no split into `pipelines` and `fragments`; the structure under `.ado/pipelines/` equals today's `pipelines/`.
- Everything else stays the same on disk except the track configs (`variants.yml` declares the `pipelines` place with `vendor: ado`).
- The docs write "azure devops pipelines" or "ado pipelines" for the vendor variant and keep "pipelines" for the generalized concept.
- `eac`'s docs are inspiration for what a real CI/CD pipeline is (idea only, said so where used; ADR-PRIN-ONELIVE: rebuilt to catzc rules).
- `docs/adr/pipelines` is split, not just renamed: the real pipeline concepts that have nothing to do with ado go to `docs/adr/flow`, and
  the ADRs specific to azure devops pipelines go to a new `docs/adr/ado` domain with `ADR-ADO-*` codes.

## Open steps

- [ ] Re-point the `pipelines` place in `pwsh/Catzc.Base.Variants/configs/variants.yml` and the track-type entry to `.ado/pipelines` (check:
      the track resolves the moved files; Test-Pipelines clean). The `git mv` of the folder is the user's.
- [ ] Sweep every caller that names the root `pipelines/` path, one file at a time (check: `Grep` for the old path finds nothing).
- [ ] Classify each ADR in `docs/adr/pipelines` (`pipeline-naming-and-placement`, `custom-template-discipline`, `dual-authentication`,
      `pipeline-variables`, `dora-explains`) as concept or ado-specific, rule by rule where one file holds both, and write the table here
      (check: every rule has a destination, the user confirms any doubtful one).
- [ ] Move the ado-specific rules to `docs/adr/ado` and the concept rules to `docs/adr/flow`, one ADR at a time, with `Update-AdrCitation`
      re-citing every `ADR-PIPE-*` code (including the one `.markdownlint.yml` cites) (check: Test-Adr and Test-Links clean after each
      move).
- [ ] Write the CI/CD concept ADR in `docs/adr/flow` (what a pipeline, a stage and a gate are, vendor-neutral), citing the existing flow
      ADRs instead of repeating them (check: Test-Adr clean, index lists the new codes).
- [ ] Re-word the ado-only ADRs and articles to "azure devops pipelines" / "ado pipelines" (check: a grep for bare "pipeline" in the ado
      ADRs names only the concept uses).

## Refs

- docs/adr/flow/pipeline-types.md, pipeline-runner-pattern.md, cd-discipline-and-promotion-flow.md.
- plan-promotion-ladder targets the same `pipelines` tree; its `targets` re-point when this move lands.
