---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Languages,
      pwsh/Catzc.Base.QualityGates,
      pwsh/Catzc.Base.Contracts,
      contracts/catzc/0.0.0,
      python,
      go,
      docs/adr/automation/idiomatic-names.md,
    ]
---

# Idiomatic names: every language names its own way, and contracts name in one normal form

Each source language names its files, folders, functions and types in its own idiom: PowerShell `Get-CommandContract.ps1` in
`Catzc.Base.Contracts/`, Python `get_command_contract` in `catzc_diagrams/`, Go `GetCommandContract` in `catzcbaserepository/`. Under the
idioms sits one **repository normal form**, configured as `snake`; each idiom is a rendering of it, and the command contracts in
`contracts/catzc/0.0.0` are written in it.

## Why its value is high

A name in its language's idiom is the one that language's readers and tools expect (Python imports a package by an identifier; Go wants one
lowercase word per package directory). A contract in PowerShell's spelling binds every other language to it; in the normal form, a contract
states an interface once and each language's checker renders its own name.

## Decided (the user, 2026-10-20)

Every decision is a rule of [idiomatic-names](../../docs/adr/automation/idiomatic-names.md) (`ADR-AUTO-IDIOM`), with the contract side in
[command-contracts](../../docs/adr/repository/command-contracts.md) and [api-contracts](../../docs/adr/repository/api-contracts.md):

- The idiom is a `naming:` entry per language in `languages.yml`, from a closed set of cases (ADR-AUTO-IDIOM-LANGUAGEIDIOM,
  ADR-AUTO-IDIOM-CLOSEDCASES); assets, vendored folders and listed files keep their source's names (ADR-AUTO-IDIOM-SOURCENAMEDEXEMPT).
- PowerShell is correct as it is; Python and Go are renamed to their idiom: `python/Catzc.Diagrams/`, `python/tests/catzc-base-repository/`
  and `go/tests/catzc-base-repository/` are the three misnamed folders.
- The normal form is a configured case, the best of all worlds even when it is one language's idiom: `snake` (ADR-AUTO-IDIOM-NORMALFORM);
  every name round-trips (ADR-AUTO-IDIOM-ROUNDTRIP); an acronym is one ordinary word, never a list (ADR-AUTO-IDIOM-ACRONYMISWORD).
- A test folder is its module's normal form in its language's folder case (ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM).
- Contracts in `0.0.0` use the normal form for the command file name, the module folder, parameters, sets and types; `cats` takes the POSIX
  rendering, kebab (ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE, -NOPLACEMENTFACTS, -CHECKERPERLANGUAGE, -ONEREADER, ADR-REPO-CONTRACT-LAYOUT). No
  `catzc` version is released, so the draft changes in place with every caller (ADR-PRIN-ONELIVE).

## Open steps

### 1. Wire it in

Turn the gate on, last, when it is green; `Test-IdiomaticNames` reads the git index (ADR-AUTO-TRACKED), and the three folder renames are
tracked (`python/catzc_diagrams/`, `python/tests/catzc_base_repository/`, `go/tests/catzcbaserepository/`):

- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: add `Test-IdiomaticNames` to the `checks` of `powershell`, `python`, `go` and
      `bash` (check: `Test-IdiomaticNames` reports no issue; `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1`).

### 2. The repository normal form

The word model, the 15 acronym renames, the helper renames, the manual-test-plan rows and `Repair-IdiomaticNames` landed on 2026-10-21; the
L1 round trip in `ConvertTo-NormalName.Tests.ps1` passes once the user commits the case-only renames with `git mv`.

From the session's finalizer (catzc-73, 2026-10-21); its `catzc-verify` line and the rename how-to landed:

- [ ] `CommentPageMap.cs` (in `Catzc.Base.CodeMeta`), `Get-ReadmeMappings.ps1`, `Get-ModuleGlobSet.ps1` and
      `Get-ModuleProtectionIdentity.ps1` render `{kebab}` by `ToLowerInvariant().Replace('.', '-')`; moving them to `LanguageNaming` renames
      the `catzc-base-*` reference pages, so it waits on the user's yes (check: the user answers; then `Invoke-TestFile` on each one's tests
      and `Test-GeneratedFiles`).

## Open questions

- From catzc-73's finalize (2026-10-21): `catzc-verify` step 1 names the import-path readers of a folder rename, but not that the import's
  lookup janitor (`New-CatsCommandLookup`) runs every contract reader, so a reader edit ahead of its data turned every session's import red.
  Should step 1's clause say "the contract readers" too? Recommendation: yes, three words merged into the existing list.
- Same finalize: `LanguageNaming.IsInCase` is false for a dotted name, so every caller with a module or type name splits on `.` first.
  Should `LanguageNaming` take a dotted name in one call, the way `FromNormal` already does? Recommendation: yes, one method, its callers in
  the same pass.
- Same finalize: `Format-Code` on a C# type file changes the types hash, so a gate run right after in the same process looks for a DLL the
  next import builds. Should `catzc-verify` step 2 say to format before the fresh import? Recommendation: yes, an order clause merged into
  the step.

## Refs

- [idiomatic-names](../../docs/adr/automation/idiomatic-names.md), [command-contracts](../../docs/adr/repository/command-contracts.md),
  [api-contracts](../../docs/adr/repository/api-contracts.md)
- `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`, `types/LanguagesConfig.cs` (`MisnamedPaths`), `configs/languages.yml`
- `pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1`, `Assert-IdiomaticNames.ps1`
