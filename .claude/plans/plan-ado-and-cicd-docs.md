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
- The repository-rooted paths inside the moved tree follow it (catzc-2f [2a36a7] for the orchestrator, 2026-10-19): every
  `template: /pipelines/…` becomes `template: /.ado/pipelines/…` and every `./pipelines/Invoke-AdoScript.ps1` becomes
  `./.ado/pipelines/Invoke-AdoScript.ps1`, because Azure DevOps resolves both from the repository root and the old paths no longer exist;
  `Test-Pipelines` derives the root and the template prefix from the `ado-pipelines` track's place instead of a literal. Re-registering the
  pipelines' YAML paths in Azure DevOps is the user's.
- The `adrs.yml` domain key follows the ADR file move at once (catzc-2f [2a36a7], approved by the orchestrator, 2026-10-19): `pipelines`
  becomes `ado` and `languages.yml` `adr_folder` follows, because `Build-AdrIndex` reads the domain's folder from its key and the importer
  stopped on the missing folder; the codes stay `ADR-PIPE-*` until the re-cite step.
- The new codes (catzc-2f [2a36a7], 2026-10-19): the domain code is `ADO` (`ADR-ADO-AUTH`, `-VAR`, `-NAME`, `-TEMPLATE`, file names kept),
  and the concept ADR is `docs/adr/flow/pipeline-concept.md` as `ADR-FLOW-CD-PIPELINE`, in the `ADR-FLOW-CD-*` family beside RUNNER, DETECT,
  TYPE and GLOBS; the four concept rules keep their names (`ADR-FLOW-CD-PIPELINE-TYPEPREFIX`, `-EXECUTABLEYAMLEXTENSION`,
  `-FLATREADABLEYAML`, `-NOSTOREDTOKENS`). The re-cite maps are `out/ado-code-map.tsv` and `out/ado-rule-map.tsv`. The value-chain
  `stack: PIPE` row is a stack name, not a code, and stays. The idea of a pipeline as the automated path from commit to production, one per
  deployable unit and run on change detection, came from `eac`'s CD-model pages, rebuilt from catzc's own rules (ADR-PRIN-ONELIVE).
- The reference pages follow the place (catzc-2f [2a36a7], 2026-10-19): `docs/references/pipelines(.md)` moves to
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

- [x] Rename the track `pipelines` to `ado-pipelines` in `pwsh/Catzc.Base.Variants/configs/variants.yml:24` and re-point its place to
      `.ado/pipelines`, then every consumer that names the track by key (`git grep -n "'pipelines'" -- pwsh`, one file at a time; the
      `pipeline:` keys of `globs.yml` name pipelines, not the track, and stay) (check: the track resolves the moved files; Test-Variants,
      Test-TrackDeclaration and Test-Pipelines clean). The `git mv` of the folder is the user's (task-user-runs-and-commits). Verdict
      2026-10-19: the track key consumer is `WorldMapBuilder.AdoPipelinesTrack`; Test-Pipelines over `.ado/pipelines` "No pipelines issues
      found." (14 YAML files); Test-TrackDeclaration passes (void, throws on an issue); WorldMapBuilder and WorldMapHighlight tests Passed.
      No Test-Variants gate exists. The moved runner climbs `../../importer.ps1`.
- [x] After the user's `git mv` of `docs/explanation/pipelines/` to `docs/explanation/ado/`: re-point the links into and out of the 25 files
      and regenerate the folder's `.assets` pages (check: Test-Links over docs/ clean; `Build-Diagrams -Path` over the moved folders clean;
      `docs/references/pipelines/` regenerates under the new place with `Build-Readme`, and the old reference folder is gone). Verdict
      2026-10-19: `Build-Diagrams -Path` over the 5 moved diagram folders done; Build-Readme ran with `readme.yml` on
      `docs/references/ado/pipelines(.md)`; the 15 kept comment pages retitled, Build-CommentView placed 14 views and Test-Comments "No
      comments issues found."; Test-Links over the touched docs and the 19 reference pages "No links issues found."
- [x] Re-point the two code files and the four configs under `pwsh/` that name the root path, one file at a time, then the eight test files
      (check: each file's test under `Invoke-TestFile` passes; `git grep -E '(^|[^a-zA-Z/.])pipelines/' -- pwsh` finds nothing). Verdict
      2026-10-19: `Test-Pipelines` and `Test-AdoPipelineTriggerGlob` read the place from the `ado-pipelines` track; Test-Pipelines,
      Test-AdoPipelineTriggerGlob, Get-PathModule, CommentsConfig and Build-GitKeep tests Passed; the grep finds only self-contained L0
      fixtures that declare their own `pipelines` place (WorldMap*, GlobPattern, Build-GitKeep), which stay.
- [x] Re-point the eight contract fragments under `contracts/catzc/0.0.0/Catzc.Azure.DevOps/` as one contract change (check: Test-Contracts
      clean; the released folders stay frozen). Verdict 2026-10-19: the fragments stay at `Catzc.Azure.DevOps/pipelines/` and
      `contracts.yml` declares the target root `Catzc.Azure.DevOps: .ado` (a dot folder under `contracts/` is refused,
      ADR-REPO-CONTRACT-NODOTFOLDERS); the fragment headers and `Test-Pipelines.command.yml` name `.ado/pipelines/`; Test-Contracts "No
      contracts issues found."
- [ ] Re-point `.gitattributes`, the three `docs/how-to` pages and the 15 non-generated `docs/explanation` articles, one file at a time; the
      307 generated `.assets` pages and the `docs/references` pages are regenerated, not edited (check: `Build-Diagrams -Path` over the
      touched folders and `Build-Readme` clean; Test-Links over docs/ clean). Done 2026-10-19: every hand-written page re-pointed (13 ADRs,
      10 explanation articles, 2 how-tos, the 2 reference pages, the `.gitattributes` template, which regenerates `.gitattributes`);
      Build-Readme ran and Test-Links over the touched docs is clean. Open: the 154 generated `.assets` folders (all of `docs/explanation`
      plus 3 in `docs/adr`) regenerate on the user's `Build-Diagrams` run before the final full run (the orchestrator on the user's
      delegation, 2026-10-19: not batched here; the run is in task-user-runs-and-commits).
- [x] Move the 23 ado rules, by file, to `docs/adr/ado` as `ADR-ADO-*`, and the 4 concept rules into the concept ADR below, with
      `Update-AdrCitation` re-citing every `ADR-PIPE-*` code in the 50 citing files (check: Test-Adr and Test-Links clean after each move;
      `docs/adr/pipelines` is gone; the index lists no ADR-PIPE code). Verdict 2026-10-19: Test-AdrRegistry "No adr-registry issues found.",
      Test-AdrEngineNeutrality and Test-Links over the 28 touched docs clean, `docs/adr/pipelines` gone, the index lists 0 ADR-PIPE codes.
- [x] `Update-AdrCitation` rewrites only path and code mentions of a moved ADR folder, never a bare word (the orchestrator on the user's
      delegation, 2026-10-19): the re-cite above turned the bare word "pipelines" into "ado" in about 150 places of prose, repaired file by
      file against 52a11dce7 with `out/ado-unbreak.ps1`. It runs right after the repair, before plan-adr-automation-split re-cites 287 files
      with the same tool (check: an L0 test whose fixture prose holds the folder's bare name, which comes out unchanged, passes under
      `Invoke-TestFile`; the existing Update-AdrCitation tests still pass). Verdict 2026-10-19: `AdrCitationRewriter` matches a one-segment
      folder only followed by '/', a multi-segment folder as before; `Update-AdrCitation.Tests.ps1` with the new "leaves its bare name in
      prose alone" test Passed under `Invoke-TestFile`.
- [x] Write the CI/CD concept ADR in `docs/adr/flow` (what a pipeline, a stage and a gate are, vendor-neutral), holding the four concept
      rules and citing the 48 existing flow rules instead of repeating them (check: Test-Adr clean, index lists the new codes). Verdict
      2026-10-19: `docs/adr/flow/pipeline-concept.md` with its `dora-explains.md` entry; Test-AdrRegistry clean; the index lists
      `ADR-FLOW-CD-PIPELINE`.
- [x] Re-word the ado-only ADRs and articles to "azure devops pipelines" / "ado pipelines" (check: a grep for bare "pipeline" in the ado
      ADRs names only the concept uses). Verdict 2026-10-19: the five `docs/adr/ado` files name the vendor variant "ado pipeline(s)" and its
      place `.ado/pipelines/`; the bare "pipeline" left names the concept (pipeline concerns, pipeline file, pipeline detection) or quotes a
      source title.
- [ ] For the diagram track (plan-diagram-engine, held by catzc-cc; a `write-drawio-files` job): three flow drawings still label the old
      root path while their articles name `.ado/pipelines/` —
      `docs/explanation/flow/.assets/apex-thirteen-rules-seven-includes-six-excludes` element 8,
      `docs/explanation/flow/.assets/globs-projects-and-three-consumers-read` element 8, and
      `docs/explanation/flow/.assets/print-projection-then-drift-names-the-filter` elements 3 and 8 (check: each drawing's label reads
      `.ado/pipelines/…` and its `Build-Diagrams -Path` run is clean).

## Refs

- docs/adr/flow/pipeline-types.md, pipeline-runner-pattern.md, cd-discipline-and-promotion-flow.md.
- plan-promotion-ladder and plan-explanation-drift-gaps target the same `pipelines` tree; their `targets` re-point when this move lands.
- Shared files with other plans, in the master's order: `.markdownlint.yml` is switched from a hard link to a headed copy by
  plan-generated-file-heads before this plan re-cites its ADR-PIPE code; `globs.yml` is edited by the layers P6 (pipeline names) and not by
  this plan; `adrs.yml` and the regenerated `docs/adr/index.md` are touched by this plan, plan-adr-automation-split, plan-diagram-engine,
  plan-iac-and-repo-placement and plan-generated-file-heads, each through `adrs.yml` and `Build-AdrIndex`, never by hand.
