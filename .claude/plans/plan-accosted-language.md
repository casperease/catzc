---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Languages/configs/languages.yml,
      pwsh/Catzc.Base.Languages/configs/glossary.yml,
      pwsh/Catzc.Base.QualityGates/configs/terminology.yml,
      pwsh/Catzc.Base.Contracts,
      pwsh/Catzc.Base.Docs/configs/adrs.yml,
      pwsh/Catzc.Base.Timeouts/configs/timeouts.yml,
      docs/adr/automation,
      docs/adr/index.md,
      contracts/catzc/0.0.0,
    ]
---

# Accosted language

**accosted** is a simple cats language variant: a file is a long flat list of runs, each run a short list of harmless simplified commands,
each command written in the contract form, a contracted command's normal-form name with literal arguments
(`get_file_language: { path: README.md }`). It has no syntax of its own: no variables, pipes, branches, loops or output passed between
commands. The word is reserved: it names this language and nothing else in the repository (the stance `ADR-PRIN-CATS-CATZCISSOURCENAME`
takes for catzc).

## Why its value is medium

It gives the contracted surface a long, safe, readable list of calls that proves every harmless command answers from every engine, in the
one notation the contracts already use. Nothing breaks without it, so medium.

## Decided (the user, 2026-10-21)

- **The name is reserved**: "accosted" appears only where it names this language (its row, extension, ADR, glossary entry, module types and
  tests); a gate fails it anywhere else.
- **Harmless is a verb allow-list declared once in config** (`ADR-PRIN-CONFIG`, `ADR-AUTO-DEFAULT-ONERESOLUTIONORDER`): a command is
  harmless when its contract exists and its verb is on the list; the contract language gets no new key
  (`ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE` stays as it is).
- **It runs through `cats` under every engine** (`ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE`: a contracted command is proven from every
  engine), each run bounded (`ADR-AUTO-FAILFAST-BOUNDEVERYWAIT`).
- **The file form is `<name>.accosted.yml`**, so prettier and the YAML tooling apply unchanged.
- **Its purpose is a smoke suite of the contracted surface** (the planner's reading of "long list of small harmless executions"): each
  module may carry `accosted/*.accosted.yml` beside its commands, the folder its layout row names.
- **Reader and runner live in `Catzc.Base.Contracts`** (the planner's choice, 2026-10-21): the language is contract form only, so the module
  that owns the contract reader and the cats lookup owns it.
- **A write confined to `out/` is harmless** (decision round 2026-10-21, Q1): a `Test-*` gate with an `output_folder` argument under `out/`
  (`ADR-REPO-OUTDIR`) is harmless; the reader rejects any other path argument that names a write target. The ADR's harmless rule says so.

## Open steps

The ADR and the reserved word go first, so every later file has a rule to cite.

- [ ] `.claude/plans/plan-master.md`: the planner adds this plan's chunk line once no peer has the file dirty (it was dirty on 2026-10-21)
      (check: `Test-Plans`).

- [ ] `docs/adr/automation/accosted-language.md` (new, `New-Adr`): the ADR `ADR-AUTO-ACCOSTED` with rules for the file form (a `runs:` list
      of command lists), the command form (contract-form name, literal arguments of the contract's closed types), harmless (contracted and
      on the configured verb list), the reserved name, one reader, and the runner (cats, every engine, bounded) (check: `Test-AdrIndex`,
      `Test-Links` on the page).
- [ ] `pwsh/Catzc.Base.Docs/configs/adrs.yml` and `docs/adr/index.md`: register `accosted-language` under `automation` (check:
      `Test-AdrRegistry`).
- [ ] `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`: a `reserved` category whose `scope` lists the only paths "accosted" may appear
      in, and the term under it; if `Test-Terminology` does not enforce a category's scope today, that enforcement is the next step's edit
      (check: `Test-Terminology` on the file).
- [ ] `pwsh/Catzc.Base.QualityGates/Test-Terminology.ps1`: fail a `reserved` term outside its category's scope, with L0 tests on a widget
      fixture term (check: `Invoke-TestFile` on its test file).
- [ ] `pwsh/Catzc.Base.Languages/configs/glossary.yml`: the term **accosted** with its defining rule `ADR-AUTO-ACCOSTED`, then
      `Build-Glossary` (check: `Test-Glossary`).
- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: the `accosted` row, extension `.accosted.yml`, formatter prettier, the yaml checks,
      `adr_folder: automation`, layout `{ folder: accosted, role: run-list }` (check: `Catzc.Base.Languages` Pester).
- [ ] The file-language resolver (`Get-FileLanguage` and its type in `Catzc.Base.Languages`): resolve the longest matching extension, so
      `x.accosted.yml` is accosted and `x.yml` stays yaml; one file per step (check: `Invoke-TestFile` on `Get-FileLanguage.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Contracts/configs/accosted.yml` and its type `pwsh/Catzc.Base.Contracts/types/AccostedConfig.cs`: `harmless_verbs`
      (`get`, `test`, `find`, `measure`) and the run bound's timeout key, defaults on the type; register in `configs.yml` (check:
      `Invoke-TestFile` on `tests/types/AccostedConfig.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Contracts/types/AccostedFile.cs`: the typed record, a file of runs, a run of commands, a command of a normal-form
      name and literal arguments (check: `Invoke-TestFile` on `tests/types/AccostedFile.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Contracts/Get-AccostedFile.ps1`: the one reader; it rejects a command no contract names, a verb not on the list, an
      unknown or missing parameter, and a value outside the contract's type, each with the contract's message, from the committed cats
      lookup (check: `Invoke-TestFile` on its test file, widget/gadget fixtures, `ADR-REPO-LANG-LOGICUSESFIXTURES`).
- [ ] `pwsh/Catzc.Base.Timeouts/configs/timeouts.yml`: the `accosted_run` limit for one run (check: `Catzc.Base.Timeouts` Pester).
- [ ] `pwsh/Catzc.Base.Contracts/Invoke-Accosted.ps1`: runs every run of a file through `cats` under each engine of the engine registry,
      each run bounded by `accosted_run`, and returns one result per run and engine (check: `Invoke-TestFile` on its test file).
- [ ] `contracts/catzc/0.0.0/Catzc.Base.Contracts/get_accosted_file.command.yml` and `invoke_accosted.command.yml`: both commands contracted
      (check: `Test-Contracts`).
- [ ] `pwsh/Catzc.Base.Contracts/accosted/contracts.accosted.yml`: the first file, one run per harmless command of `Catzc.Base.Contracts`
      (check: `Invoke-Accosted -Path` on it, every run green under every engine).

## Refs

- `docs/adr/repository/command-contracts.md` (`ADR-REPO-CMDCONTRACT`): the contract form a command line is written in, and the cats lookup.
- `docs/adr/principles/cats-and-catzc.md` (`ADR-PRIN-CATS`): the reserved-token stance the name copies.
- `docs/adr/automation/execution-engines.md` (`ADR-AUTO-ENGINE`): the engines a run goes through.
- `docs/adr/automation/dry-run.md` (`ADR-AUTO-DRYRUN`), `docs/adr/automation/idempotent-state-functions.md` (`ADR-AUTO-IDEM`): what a side
  effect is.
