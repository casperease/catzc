---
plan:
  status: blocked
  value: high
  reviewed: 2026-10-19
  waits_on: P6 pipeline renames wait for the user's go, the same day the user re-points the GitHub bindings
  targets: [pwsh, docs/adr/automation, docs/adr/repository, contracts, pwsh/Catzc.Base.Docs/configs]
---

# Automation is the abstract term; the PowerShell track is named pwsh; public commands get contracts

Open: P6, the externally bound pipeline names and the last old layer form.

## Why its value is high

It fixes what automation, language, engine, importer, command and contract mean across every file, and makes contracts/ the only public API
by naming which public functions are contracted. Every later plan speaks this vocabulary.

## Decided, and why

- 2026-10-16, all took the recommendation: `invoke-automation.yaml` and `release-automation.yml` keep their names (they invoke and release
  the automation, the abstract thing); `Test-Automation`, its helpers and `test-automation/` keep theirs; the concern `automation`, the
  value-chain row AUTO and the `ADR-AUTO-*` codes are never re-coded; bash, python and go stay test-artifact languages; P6 renames
  `ci-automation`, `ci-automation-expected-failures` and the globset, and the user re-points the GitHub bindings outside git the same day
  (no Azure DevOps organization is connected yet); nothing is rendered unasked.
- This plan closes when P6 lands.

## Open steps

- [ ] P6 pipeline and unit names, one atomic set (task-layers-classification-flip step 1): `ci-automation` -> `ci-pwsh`,
      `ci-automation-expected-failures` -> `ci-pwsh-expected-failures` in `.github/workflows/ci-automation.yml`,
      `.ado/pipelines/ci-automation.yaml`, `.ado/pipelines/ci-automation-expected-failures.yaml`, the globset and `pipeline:` key, their
      name-keyed contract fragments under `contracts/catzc/0.0.0/` (the assets pin the file names, so the fragments move with the files),
      `docs/references/pipelines/*`, the `.github/README.md` badge, the `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline`
      examples, and ADR-DSGN-TRACK-DEPLOYABLEUNIT's "as `ci-automation` binds the automation track". With it, the `automation` form leaves
      the layer family in `glossary.yml`. Not swept: `System.Management.Automation`, `NoAutomaticVariableMisuse.psm1`, CAF/WAF/DORA titles
      and anchors, "Cloud Automation Toolkit", Exporter `-Version auto`, `jidoka`, `.markdownlint.yml` "auto-enable",
      `Get-AutoControlledGlobs` (the name keeps "Auto"), `ADR-AUTO-*` codes and paths, `.unordered/**`. The user's go first (check:
      Test-Pipelines, Test-Contracts and Test-Glossary clean; the triggers fire on the next push after the user re-points the bindings).

## Refs

- memory: automation-layers-rename-plan.md; the four drafts (master, layer model, command contracts, rename worklist) are in git.
- Contract traps: a contract asset is bytes the check compares (`catzc-contract` in `.gitattributes`, no Format-Code pass rewrites it);
  released folders are frozen (`.frozen` SHA-256, `Publish-ContractRelease`); a signature change to a contracted command edits the asset in
  the same commit; a contract stores no version, module or language (placement says them). Other implementing languages wait for a real
  command in one (ADR-AUTO-GO/PY/BASH); until then `NotImplemented` (ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS).
- The Azure DevOps and GitHub settings outside git, the commit structure, and `.unordered/` are the user's and out of this plan.
