---
plan:
  status: blocked
  value: high
  reviewed: 2026-10-19
  waits_on: P6 pipeline renames wait for the user's go, the same day the user re-points Azure DevOps and GitHub
  targets: [pwsh, docs/adr/automation, docs/adr/repository, contracts, pwsh/Catzc.Base.Docs/configs]
---

# Automation is the abstract term; the PowerShell track is named pwsh; public commands get contracts

`automation/` is `pwsh/`, ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER and ADR-REPO-CMDCONTRACT are written, the contracted command set is in
`contracts/`, and the glossary carries the avoid-phrasings of the retired layer words (P5). Open: P6, the externally bound pipeline names
and the last old layer form; the stray pwsh rules still in AUTO ADRs; and the contract drift test.

## Why its value is high

It fixes what automation, language, engine, importer, command and contract mean across every file, and makes contracts/ the only public API
by naming which public functions are contracted. Every later plan speaks this vocabulary.

## Decided, and why

- 2026-10-16, all took the recommendation: `invoke-automation.yaml` and `release-automation.yml` keep their names (they invoke and release
  the automation, the abstract thing); `Test-Automation`, its helpers and `test-automation/` keep theirs; the concern `automation`, the
  value-chain row AUTO and the `ADR-AUTO-*` codes are never re-coded; bash, python and go stay test-artifact languages; P6 renames
  `ci-automation`, `ci-automation-expected-failures` and the globset, and the user re-points the Azure DevOps and GitHub bindings outside
  git the same day; nothing is rendered unasked.
- Public API (F6, S5, D21): internal is internal to its module; the pilot contracts are hand-written; generating a contract from the ADR
  that defines it is a direction tried on the second set.
- 2026-10-19, the user: the importer-mix build (L3 to L5) is its own plan, `plan-importer-mix.md`; this plan closes when P6 and the two
  steps below land.

## Done

- P7 (2026-10-18, D26, D27, task-command-contracts): five dead functions left the tree, the Test/Assert pair halves and debug writers stay
  exported, the how-to-named commands the grammar can state are contracted; `CONTRACTS issues=0`, 65 contracted commands; the parameter-set
  grammar and the QualityGateResult gate contracts landed; the test runners return TestRunResult and IsolationRunResult and are contracted.

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
- [x] Superseded 2026-10-19 by plan-adr-automation-split's sort step (Test-AdrEngineNeutrality reports 0 over these rule summaries, so they
      stay in AUTO): The stray pwsh rules in AUTO ADRs, one rule at a time: ADR-AUTO-TEST-SAFESEAMSWAPS, ADR-AUTO-TEST-PROCESSTRIPWIRE,
      ADR-AUTO-TEST-FILEPARALLELISM, ADR-AUTO-TEST-ONESCHEDULINGPOOL, ADR-AUTO-TEST-RUNSNEVERWAIT, ADR-AUTO-EXTEND-MANDATORYCONVENTIONS,
      ADR-AUTO-CACHE-IMPORTERINVALIDATES, ADR-AUTO-CACHE-LAZYBYDEFAULT and the session-cache model, ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING,
      ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES, ADR-AUTO-CONSOLE-SILENTTRANSIENTCHANGES, ADR-AUTO-NOPWD-ONEROOTACCESSOR; each moves to its
      `ADR-PWSH-*` twin with `Update-AdrCitation` or is reworded engine-neutral, and `Test-AdrEngineNeutrality` fails AUTO text with pwsh
      syntax (check: Test-Adr and Test-AdrEngineNeutrality clean after each rule; this step lands after `plan-adr-automation-split` moves
      the pwsh ADRs, so each twin has its final home). Re-cut 2026-10-19 by the orchestrator on the user's delegation: the gate reports 0
      issues over these rule summaries, so every one stays in AUTO and only its PowerShell mechanics move to the twin as Decision prose,
      inside plan-adr-automation-split's sort step; this step closes as superseded when the last of them lands.
- [x] The contract drift test, `python/tests/catzc-base-repository/test_contract_drift.py` — verdict:
      `Invoke-PythonTest -Module     Catzc.Base.Repository` passes all 4 tests on the tree under pwsh, and both drift tests pass under bash;
      ruff and Test-PythonTypes are clean. On a copy whose `Get-RepositoryFile.command.yml` renames `Path` to `File`, `test_contract_drift`
      fails with "the caller passes -Path, which the contract does not name" and "the contract makes -File mandatory, but the caller does
      not pass it".
- The drift test reads the call shape through the one reader, `(Get-CommandContract ...).Signature`, never by parsing the asset
  (ADR-REPO-CMDCONTRACT-ONEREADER). It reads from `CATZC_REPOSITORY_ROOT`, which is how a copy is proven, and single-quotes the expression
  for a POSIX engine's `cats`. It sits in the existing Python test folder, so it needs no registration entry. Recommended by catzc-08,
  2026-10-19.

## Refs

- memory: automation-layers-rename-plan.md; the four drafts (master, layer model, command contracts, rename worklist) are in git.
- Contract traps: a contract asset is bytes the check compares (`catzc-contract` in `.gitattributes`, no Format-Code pass rewrites it);
  released folders are frozen (`.frozen` SHA-256, `Publish-ContractRelease`); a signature change to a contracted command edits the asset in
  the same commit; a contract stores no version, module or language (placement says them). Other implementing languages wait for a real
  command in one (ADR-AUTO-GO/PY/BASH); until then `NotImplemented` (ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS).
- The Azure DevOps and GitHub settings outside git, the commit structure, and `.unordered/` are the user's and out of this plan.
