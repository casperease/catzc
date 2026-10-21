---
plan:
  status: active
  value: high
  reviewed: 2026-10-20
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

Turn the gate on, last, when it is green; `Test-IdiomaticNames` reads the git index (ADR-AUTO-TRACKED), so this waits on the user staging
the moves (task-user-runs-and-commits):

- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: add `Test-IdiomaticNames` to the `checks` of `powershell`, `python`, `go` and
      `bash` (check: `Test-IdiomaticNames` reports no issue; `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1`).

### 2. The repository normal form

The word model, in `Catzc.Base.Languages` (ADR-AUTO-IDIOM-CLOSEDCASES, -ROUNDTRIP, -ACRONYMISWORD):

- [ ] `docs/adr/automation/idiomatic-names.md`: confirm the landed `camel` rule (CLOSEDCASES) is in the registry (check: `Test-AdrRegistry`
      on the page).
- [ ] The helpers, each renamed to a verb-noun name with its callers, one file per step: `StripAnsi` (in five test files:
      Write-TestAutomationVerdict, Write-CmdletParameterSet, Write-Footer, Write-Header, Write-Object), `RunReset`, `RunPublish`,
      `RunAssert`, `Rec` (`Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1`), `Walk` (`Catzc.Base.Asserts/Assert-YmlNaming.ps1`), `Clone`
      (`Catzc.Base.Objects/Copy-Object.ps1`) (check: `Invoke-TestFile` on each one's test file).
- [ ] The 13 acronym commands, renamed to their round-trip spelling (`Set-LocalPsModulePath`, `Invoke-PsScriptAnalyzerFormat`,
      `Import-/Save-PsReadLineKeyHandlerSet`, `Invoke-BuildForVsCode`, `Build-/Install-VsCodeExtension`, `New-VsCodeExtensionFolder`,
      `New-VsCodeExtensions`, `New-VsCodeLaunch`, `New-VsCodePipelineSchema`, `New-VsCodeSettings`, `New-VsCodeTasks`), each with its file,
      callers, tests, contract and docs page, no alias kept, one command per step and a fresh import after each
      (ADR-AUTO-IDIOM-ACRONYMISWORD; the user, 2026-10-21). (check: `Invoke-TestFile` on its tests; after the last, the L1 round trip in
      `ConvertTo-NormalName.Tests.ps1` passes.)
- [ ] `docs/adr/repository/repository-conventions.md`, the manual test plan: a row each for `ConvertTo-NormalName.Tests.ps1`,
      `Get-DefinedName.Tests.ps1`, `Get-GridMinimapData.Tests.ps1` and `Listen.Shipped.Tests.ps1` (check: `Test-ManualTestPlan` lists none).

The gate and the repair (ADR-AUTO-IDIOM-HELDBYGATE):

- [ ] `pwsh/Catzc.Base.QualityGates/Repair-IdiomaticNames.ps1`: moves each misnamed folder or file on disk to its idiomatic name and lists
      every tracked file that names the old path, for one-file-at-a-time edits; `-DryRun` (ADR-PWSH-DRYRUN) (check: `Invoke-TestFile` on its
      tests).

The contracts in the normal form, `contracts/catzc/0.0.0`:

- [ ] `pwsh/Catzc.Base.Contracts/types/ContractCommand.cs` and `ContractParameter.cs`: read names, sets and types in the normal form (check:
      `Invoke-TestFile` on their type tests).
- [ ] `pwsh/Catzc.Base.Contracts/Get-CommandContract.ps1` and the PowerShell checker under `private/`: render the normal form to `verb-noun`
      and PascalCase parameters before comparing with the file (check: `Invoke-TestFile` on their tests).
- [ ] `contracts/catzc/0.0.0/<Module>/`: each module folder moved to its normal form (`catzc.base.contracts/`), the pipeline assets under
      `catzc.azure.devops/pipelines/` with it, one folder per step (check: `Test-Contracts`).
- [ ] `contracts/catzc/0.0.0/**/*.command.yml`: each asset renamed and rewritten in the normal form, one file per step (check:
      `Test-Contracts`).
- [ ] `pwsh/Catzc.Base.Contracts/New-CatsCommandLookup.ps1`: the committed lookup keys by the normal form (check: `Invoke-TestFile` on its
      tests, `Test-GeneratedFiles`).
- [ ] The `cats` entry of each engine: take the command and its parameters in kebab case and map them through the lookup's normal form
      (check: the bash and pwsh tests of `cats`, `Invoke-BashTest`).

From the session's finalizer (catzc-73, 2026-10-21):

- [ ] `.claude/skills/catzc-verify/SKILL.md`: one line, within its roof, that a rename of a folder the tooling names lands its import-path
      readers (Build-RootConfig's project writers, `Get-LanguageTestFolders`) in the same pass (check: `Test-AgentDefinitions`).
- [ ] `docs/how-to/automation/rename-a-tooling-folder.md` (new): the prepared, applied-in-one-burst, rolled-back-whole pattern of the two
      renames (check: `Test-Links` on the page).
- [ ] `CommentPageMap.cs`, `Get-ReadmeMappings.ps1`, `Get-ModuleGlobSet.ps1` and `Get-ModuleProtectionIdentity.ps1` render `{kebab}` by
      `ToLowerInvariant().Replace('.', '-')`; moving them to `LanguageNaming` renames the `catzc-base-*` reference pages, so it waits on the
      user's yes (check: the user answers; then `Invoke-TestFile` on each one's tests and `Test-GeneratedFiles`).

## Refs

- [idiomatic-names](../../docs/adr/automation/idiomatic-names.md), [command-contracts](../../docs/adr/repository/command-contracts.md),
  [api-contracts](../../docs/adr/repository/api-contracts.md)
- `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`, `types/LanguagesConfig.cs` (`MisnamedPaths`), `configs/languages.yml`
- `pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1`, `Assert-IdiomaticNames.ps1`
