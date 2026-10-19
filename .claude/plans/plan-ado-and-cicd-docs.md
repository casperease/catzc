---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets: [.ado/pipelines, pwsh/Catzc.Base.Variants/configs/variants.yml, docs/adr/flow, docs/adr/ado, docs/explanation/ado, contracts]
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
- Everything else stays the same on disk except the track configs (`variants.yml:24` declares
  `pipelines: { places: [pipelines], type: pipelines, vendor: ado, languages: [pipeline-yaml, powershell] }`).
- The docs write "azure devops pipelines" or "ado pipelines" for the vendor variant and keep "pipelines" for the generalized concept.
- `eac`'s docs are inspiration for what a real CI/CD pipeline is (idea only, said so where used; ADR-PRIN-ONELIVE: rebuilt to catzc rules).
- `docs/adr/pipelines` is split, not just renamed: the real pipeline concepts that have nothing to do with ado go to `docs/adr/flow`, and
  the ADRs specific to azure devops pipelines go to a new `docs/adr/ado` domain with `ADR-ADO-*` codes.
- The doc folders follow (the user, 2026-10-19): `docs/explanation/pipelines/` (25 files, all on ado auth and variables) becomes
  `docs/explanation/ado/`, a user `git mv`; `docs/references/pipelines/` is generated from the track's place and follows `.ado/pipelines`
  through its generator, not by hand.
- The track key follows too (the user, 2026-10-19): `pipelines:` in `variants.yml` becomes `ado-pipelines:`, as `github-workflows` already
  names its vendor; the type `pipelines` stays the concept, and every consumer that names the track is re-pointed in the same change.
- The repository-rooted paths inside the moved tree follow it (catzc-64 for the orchestrator, 2026-10-19): every `template: /pipelines/…`
  becomes `template: /.ado/pipelines/…` and every `./pipelines/Invoke-AdoScript.ps1` becomes `./.ado/pipelines/Invoke-AdoScript.ps1`,
  because Azure DevOps resolves both from the repository root and the old paths no longer exist; `Test-Pipelines` derives the root and the
  template prefix from the `ado-pipelines` track's place instead of a literal. Re-registering the pipelines' YAML paths in Azure DevOps is
  the user's.
- The `adrs.yml` domain key follows the ADR file move at once (catzc-64, approved by the orchestrator, 2026-10-19): `pipelines` becomes
  `ado` and `languages.yml` `adr_folder` follows, because `Build-AdrIndex` reads the domain's folder from its key and the importer stopped
  on the missing folder; the codes stay `ADR-PIPE-*` until the re-cite step.
- The new codes (catzc-64, 2026-10-19): the domain code is `ADO` (`ADR-ADO-AUTH`, `-VAR`, `-NAME`, `-TEMPLATE`, file names kept), and the
  concept ADR is `docs/adr/flow/pipeline-concept.md` as `ADR-FLOW-CD-PIPELINE`, in the `ADR-FLOW-CD-*` family beside RUNNER, DETECT, TYPE
  and GLOBS; the four concept rules keep their names (`ADR-FLOW-CD-PIPELINE-TYPEPREFIX`, `-EXECUTABLEYAMLEXTENSION`, `-FLATREADABLEYAML`,
  `-NOSTOREDTOKENS`). The re-cite maps are `out/ado-code-map.tsv` and `out/ado-rule-map.tsv`. The value-chain `stack: PIPE` row is a stack
  name, not a code, and stays. The idea of a pipeline as the automated path from commit to production, one per deployable unit and run on
  change detection, came from `eac`'s CD-model pages, rebuilt from catzc's own rules (ADR-PRIN-ONELIVE).
- The reference pages follow the place (catzc-64, 2026-10-19): `docs/references/pipelines(.md)` moves to
  `docs/references/ado/pipelines(.md)` and the GitHub workflow comment pages leave it for `docs/references/github/workflows`; the contract
  fragments move to `Catzc.Azure.DevOps/.ado/pipelines/`, because a fragment's path inside its module folder is its target's path. All three
  are user `git mv` sets (4–6 of `out/run-user-git.ps1`); the configs naming their targets are re-pointed only after a set lands.

## What the tree holds (checked 2026-10-19)

- Callers of the root path outside the folder: `pwsh/` 15 files (code: `Test-Pipelines.ps1`, `Test-AdoPipelineTriggerGlob.ps1`; configs:
  `adrs.yml`, `readme.yml`, `file-kinds.yml`, `vscode-extensions.yml`; eight test files; `.gitattributes-template`), `contracts/` 8 files
  (`Test-Pipelines.command.yml` and seven `Catzc.Azure.DevOps/pipelines/*.yaml` fragments, which are bytes the contract check compares, so
  the path change is a contract change), `.gitattributes:1`, `docs/adr/` 20 files, `docs/how-to/` 3, `docs/references/` 25 (mostly generated
  pages), `docs/explanation/` 322 files of which 307 are generated `.assets` grid, tree and chain pages. `.github/` names it nowhere. No
  backslash form exists.
- The 27 ADR-PIPE rules split 4 concept to 23 ado: concept are ADR-PIPE-NAME-TYPEPREFIX, ADR-PIPE-AUTH-NOSTOREDTOKENS,
  ADR-PIPE-NAME-EXECUTABLEYAMLEXTENSION and ADR-PIPE-TEMPLATE-FLATREADABLEYAML (the last two were borderline; the user placed them as
  concept on 2026-10-19, since neither names an Azure DevOps construct and both hold for GitHub workflows); all six ADR-PIPE-VAR rules, six
  of seven TEMPLATE, six of seven AUTH and five of seven NAME rules name an ado construct (`extends`, `template:`, `System.AccessToken`,
  `##vso`, PAT, ado logs). The domain's `dora-explains.md` has no rules, four section citations.
- ADR-PIPE citations outside the domain: 50 files, 278 hits; `pwsh/` 6 files (`Test-Pipelines.ps1`, its test, `adrs.yml`,
  `analyzer-adr-map.yml`, and the `.markdownlint.yml` and `.prettierrc.yml` templates under `assets/root`), `docs/explanation/` 30 files
  (174, most under `explanation/pipelines/`), `docs/adr/` 3, `docs/references/` 4.
- `docs/adr/flow` holds five ADRs with 48 rules (ADR-FLOW-CD, -GLOBS, -DETECT, -RUNNER, -TYPE) for the concept ADR to cite.

## Open steps

- [ ] Rename the track `pipelines` to `ado-pipelines` in `pwsh/Catzc.Base.Variants/configs/variants.yml:24` and re-point its place to
      `.ado/pipelines`, then every consumer that names the track by key (`git grep -n "'pipelines'" -- pwsh`, one file at a time; the
      `pipeline:` keys of `globs.yml` name pipelines, not the track, and stay) (check: the track resolves the moved files; Test-Variants,
      Test-TrackDeclaration and Test-Pipelines clean). The `git mv` of the folder is the user's (task-user-runs-and-commits).
- [ ] After the user's `git mv` of `docs/explanation/pipelines/` to `docs/explanation/ado/`: re-point the links into and out of the 25 files
      and regenerate the folder's `.assets` pages (check: Test-Links over docs/ clean; `Build-Diagrams -Path` over the moved folders clean;
      `docs/references/pipelines/` regenerates under the new place with `Build-Readme`, and the old reference folder is gone).
- [ ] Re-point the two code files and the four configs under `pwsh/` that name the root path, one file at a time, then the eight test files
      (check: each file's test under `Invoke-TestFile` passes; `git grep -E '(^|[^a-zA-Z/.])pipelines/' -- pwsh` finds nothing).
- [ ] Re-point the eight contract fragments under `contracts/catzc/0.0.0/Catzc.Azure.DevOps/` as one contract change (check: Test-Contracts
      clean; the released folders stay frozen).
- [ ] Re-point `.gitattributes`, the three `docs/how-to` pages and the 15 non-generated `docs/explanation` articles, one file at a time; the
      307 generated `.assets` pages and the `docs/references` pages are regenerated, not edited (check: `Build-Diagrams -Path` over the
      touched folders and `Build-Readme` clean; Test-Links over docs/ clean).
- [ ] Move the 23 ado rules, by file, to `docs/adr/ado` as `ADR-ADO-*`, and the 4 concept rules into the concept ADR below, with
      `Update-AdrCitation` re-citing every `ADR-PIPE-*` code in the 50 citing files (check: Test-Adr and Test-Links clean after each move;
      `docs/adr/pipelines` is gone; the index lists no ADR-PIPE code).
- [ ] Write the CI/CD concept ADR in `docs/adr/flow` (what a pipeline, a stage and a gate are, vendor-neutral), holding the four concept
      rules and citing the 48 existing flow rules instead of repeating them (check: Test-Adr clean, index lists the new codes).
- [ ] Re-word the ado-only ADRs and articles to "azure devops pipelines" / "ado pipelines" (check: a grep for bare "pipeline" in the ado
      ADRs names only the concept uses).

## Refs

- docs/adr/flow/pipeline-types.md, pipeline-runner-pattern.md, cd-discipline-and-promotion-flow.md.
- plan-promotion-ladder and plan-explanation-drift-gaps target the same `pipelines` tree; their `targets` re-point when this move lands.
- Shared files with other plans, in the master's order: `.markdownlint.yml` is switched from a hard link to a headed copy by
  plan-generated-file-heads before this plan re-cites its ADR-PIPE code; `globs.yml` is edited by the layers P6 (pipeline names) and not by
  this plan; `adrs.yml` and the regenerated `docs/adr/index.md` are touched by this plan, plan-adr-automation-split, plan-diagram-engine,
  plan-iac-and-repo-placement and plan-generated-file-heads, each through `adrs.yml` and `Build-AdrIndex`, never by hand.
