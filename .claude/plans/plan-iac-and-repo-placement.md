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
- Diagrams (explanation, under `docs/explanation/azure`, each an article plus a `.assets/<slug>/` diagram folder, working names that the
  user may rename): one diagram of the three kinds and how they relate, and several diagrams of managing infrastructure through them: change
  a configuration slot, change a reusable module and see its fan-out to the templates that use it, add a template, add an environment slot.
  A configuration slot is one `<env>[-<slot>].yml` file of a template that deploys one subscription's resource group (the glossary term).
  They are authored in the markdown source format of `plan-diagram-engine` and wait for its renderer.

## Open steps

- [ ] Split the `infrastructure` track's places in `variants.yml` into the three named kinds (templates, configs, reusable modules), with
      the configs place covering each template's `configuration/` folder (check: Test-Variants clean; the track resolves the same files).
- [ ] Write the ADR rule that names the three IaC kinds and says a track, not a path, places them (check: Test-Adr clean; the rule sits in
      `docs/adr/azure` and the index lists the code).
- [ ] Write the ADR rules that define a repo: mono-repo, consumer repo, no repo, with `eac`'s docs as inspiration only (check: Test-Adr
      clean; the rules sit in `docs/adr/repository` and the index lists the codes).

- [ ] After the renderer steps of `plan-diagram-engine`, write the explanation article and diagram of the three kinds, working slug
      `three-kinds-of-infrastructure-code` in `docs/explanation/azure`: templates, configs and reusable modules, what each holds, and how a
      template pulls its configs and modules together (check: the diagram renders from its markdown; the article cites the ADR rules that
      define each kind).
- [ ] After the same renderer steps, write the four management diagrams, each its own article and folder in `docs/explanation/azure`:
      changing a configuration slot, changing a reusable module with its fan-out to the templates that use it, adding a template, and adding
      an environment slot (check: each renders from its markdown and names the track place it edits; the user reviews each one).

## Refs

- docs/adr/design/tracks.md (ADR-DSGN-TRACK); the bundle exporter note in memory (`Catzc.Base.Exporter`) for the anchor split.
