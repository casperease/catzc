---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [pwsh/Catzc.Base.Variants/configs/variants.yml, pwsh/Catzc.Azure.Templates, infrastructure, docs/adr/repository, docs/adr/azure]
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
  template (`main.bicep`, `options.yml`, `README.md`) with its `configuration/` beside it, and `infrastructure/modules/` holds the twenty
  reusable `.bicep` modules; the `infrastructure` track declares both places (`variants.yml:22-23`:
  `places: [infrastructure/templates, infrastructure/modules], type: infrastructure, vendor: azure, languages: [bicep, yaml]`).
- The three kinds are named as track places, so any repo can map each one elsewhere: IaC templates, IaC configs, IaC reusable modules.
- Diagrams (explanation, under `docs/explanation/azure`, each an article plus a `.assets/<slug>/` diagram folder, working names that the
  user may rename): one diagram of the three kinds and how they relate, and four diagrams of managing infrastructure through them: change a
  configuration slot, change a reusable module and see its fan-out to the templates that use it, add a template, add an environment slot. A
  configuration slot is one `<env>[-<slot>].yml` file of a template that deploys one subscription's resource group (the glossary term). They
  are authored as yml declarations in the format of `plan-diagram-engine` and wait for its renderer.
- The kinds are named by an optional `kinds:` map on a track entry (the orchestrator on the user's delegation, 2026-10-19, as catzc-08
  recommended): kind -> place pattern, each inside one of the track's places, one `*` segment allowed
  (`templates: infrastructure/templates`, `configs: "infrastructure/templates/*/configuration"`, `modules: infrastructure/modules`); a typed
  `kinds` property on `VariantTrack` (snake_case mirror) and a public resolver `Get-TrackPlace -Track <name> -Kind <kind>`; track membership
  (places, longest wins) is unchanged, and a consumer repo maps the kinds in its own `variants.yml`. Rejected: three tracks (splits one
  tech-stack across three tracks, ADR-DSGN-TRACK-ONETECHSTACK, and still cannot place the nested configs without wildcard places), and three
  module types in `module-types.yml` (the kinds become module shapes, not the track places decided above, and the nested configs still need
  a pattern). The rule lands in the IaC-kinds ADR step.

## What the tree holds (checked 2026-10-19)

- Three templates: `discovery` and `foundation` (`environment_kind: subscription`, slots `nsub`, `psub`, customers apex, flux, nova) and
  `expedition` (`environment_kind: standard`, slots `dev`, `test`, `preprod`, `prod`, and `dev-blu` as the one `<env>-<slot>` file,
  customers apex, nova). Slot and customer names are discovered from disk (`Get-BicepTemplates.ps1:65-68`), not from a list.
- The literal paths that bypass the track: `Get-BicepTemplatesRoot.ps1:5` (`infrastructure/templates`, used by `Get-BicepTemplates` and
  `Assert-BicepTemplate`), `Get-LiveIdentityTokens.ps1:80,83`, `Test-ConfigIdentityHygiene.ps1:24` (`infrastructure`),
  `Test-Spelling.ps1:23` and `Export-SpellingTriage.ps1:23` (the glob `infrastructure/templates/**/configuration/**`). The shape literals
  `main.bicep`, `options.yml`, `configuration/<customer>/<slot>.yml` sit in `Get-BicepTemplates`, `Assert-BicepTemplate`,
  `Read-BicepTemplateOptions` and `Set-BicepTemplateConfiguration`.
- No ADR rule in `docs/adr/azure` or `docs/adr/repository` names IaC templates, configuration slots or Bicep modules; the nearest are
  ADR-AZ-CUSTOMER-CUSTOMERTEMPLATEOPTION, ADR-AZ-DATAMOD-STAGINGSLOT and ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS. "mono-repository" is used
  without a rule in `api-contracts.md:158,313` and `conventional-folders.md:120,178`; "consumer repo" and "no repo" appear nowhere; "bundle"
  is defined in `api-contracts.md:19` as the one unit a consumer pins.
- `docs/explanation/azure/` holds fifteen articles with matching `.assets/` folders; none of the slugs below collides.

## Open steps

- [x] Split the `infrastructure` track's places in `variants.yml` into the three named kinds (templates, configs, reusable modules), with
      the configs place covering each template's `configuration/` folder (check: Test-Variants clean; Test-TrackDeclaration clean; the track
      resolves the same files). The naming is decided above (a `kinds:` map, `Get-TrackPlace`). Verdict 2026-10-19: `VariantTrack.kinds` and
      `KindPlace()`, `VariantsConfig` reads and validates `kinds:` (kebab-case kind, a pattern inside one of the track's places, at most one
      `*` segment), `Get-TrackPlace`; VariantsConfig, Get-TrackPlace (L0 and the real three kinds) and Get-Track tests Passed in a fresh
      import; Test-TrackDeclaration passes; all 46 infrastructure files still resolve to the `infrastructure` track. No Test-Variants gate
      exists.
- [x] Re-point the five literal paths above to the track's places, one file at a time, starting with `Get-BicepTemplatesRoot.ps1` (check:
      the file's test under `Invoke-TestFile` passes; `git grep "infrastructure/"` under `pwsh/` finds only `variants.yml` and comments).
      Verdict 2026-10-19: `Get-BicepTemplatesRoot` and `Get-LiveIdentityTokens` resolve the templates kind, `Test-ConfigIdentityHygiene`
      walks the track's places, `Test-Spelling` and `Export-SpellingTriage` exclude `<configs kind>/**`; Get-BicepTemplatesRoot (new),
      Get-BicepTemplates, Assert-BicepTemplate, Get-LiveIdentityTokens, Test-ConfigIdentityHygiene and Export-SpellingTriage tests Passed;
      Test-Spelling's L0 tests pass, and its L1 real-repository run fails on 10 words that are not in this chunk's files (a scoped run over
      every file changed here finds none). Decided (catzc-2f [2a36a7], 2026-10-19): the grep still finds the paths in static data, which
      cannot call the resolver and stay literal config a consumer repo edits for itself: the `file-kinds.yml` globs, the root `cspell.yml`
      asset's `ignorePaths`, and test fixtures that declare their own paths.
- [x] Write the ADR rule that names the three IaC kinds and says a track, not a path, places them (check: Test-Adr clean; the rule sits in
      `docs/adr/azure` and the index lists the code; it cites ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER and
      ADR-DSGN-TRACK-SUBSCRIBABLENOTPATHCOUPLED). Verdict 2026-10-19: `docs/adr/azure/infrastructure-kinds.md` (ADR-AZ-IACKIND, THREEKINDS
      and TRACKPLACESKINDS, citing both track rules) with its azure `dora-explains.md` entry and the `adrs.yml` ruleset; Build-AdrIndex
      lists `ADR-AZ-IACKIND`; Test-AdrRegistry "No adr-registry issues found."; Test-Spelling over the two pages clean; Test-Links' one
      issue is the new page being untracked until the user's commit.
- [x] Write the ADR rules that define a repo: mono-repo, consumer repo, no repo, with `eac`'s docs as inspiration only, and re-point the
      four bare "mono-repository" uses to the rule (check: Test-Adr clean; the rules sit in `docs/adr/repository` and the index lists the
      codes). Verdict 2026-10-19: `docs/adr/repository/repository-kinds.md` (ADR-REPO-REPOKIND-THREEKINDS, -CONSUMERREPO, -NOREPO) with its
      `dora-explains.md` entry and `adrs.yml` ruleset; the four uses in `api-contracts.md` and `conventional-folders.md` cite
      ADR-REPO-REPOKIND-THREEKINDS; Build-AdrIndex lists `ADR-REPO-REPOKIND`; Test-AdrRegistry, Test-Glossary, Test-Links and Test-Spelling
      over the four pages "No … issues found." Decided (catzc-2f [2a36a7], 2026-10-19): the product mono-repository keeps its one definition
      (ADR-THES-ONETRUTH-PRODUCTMONOREPOSITORY, the glossary term); the new ADR names it through the glossary instead of citing the thesis
      code, because the repository domain does not depend on thesis (Test-AdrRegistry refuses the citation). From `eac`'s trunk page the
      idea taken was naming repository kinds at all; its poly/mono split was not, since catzc's kinds are where the tooling runs, not how
      code is split. Done (the orchestrator on the user's delegation, 2026-10-19): `conventional-folders.md`'s "hardcoded paths" section
      says a literal folder name is for a module-internal contract folder, never for a track's place, citing ADR-REPO-REPOKIND-THREEKINDS
      and ADR-DSGN-TRACK-SUBSCRIBABLENOTPATHCOUPLED (not ADR-AZ-IACKIND, because the repository domain does not depend on azure);
      Test-AdrRegistry, Test-Glossary, Test-Links and Test-Spelling on the page found no issues.

## Refs

- docs/adr/design/tracks.md (ADR-DSGN-TRACK, 18 rules); the bundle exporter note in memory (`Catzc.Base.Exporter`) for the anchor split.
- The five explanation diagrams this plan decided (the three kinds, and the four management diagrams) are authored by `plan-diagram-engine`,
  the isolated diagram track, after the two ADR rule steps above land; this plan closes on its four steps alone.
