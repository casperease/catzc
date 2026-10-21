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

The citations:

- [ ] `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1`: re-tag the two naming tests `ADR-AUTO-IDIOM-LANGUAGEIDIOM` (check:
      `Invoke-TestFile` on it).
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Test-IdiomaticNames.Tests.ps1`: re-tag `ADR-AUTO-IDIOM-HELDBYGATE` (check: `Invoke-TestFile`).
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Assert-IdiomaticNames.Tests.ps1`: re-tag `ADR-AUTO-IDIOM-HELDBYGATE` (check: `Invoke-TestFile`).

The test folders map by their language's folder case (ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM):

- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: give `bash` its entry, `naming: { folder: kebab, file: kebab }` (check:
      `Test-IdiomaticNames -PassThru` lists no bash finding).
- [ ] `pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1`: map each test folder to its module by rendering the module's
      normal form in the folder's language case, not by `ToLowerInvariant().Replace('.', '-')`; the throw names the expected case (check:
      `Invoke-TestFile` on its tests). Waits on the word model in part 2.
- [ ] `pwsh/Catzc.Base.Languages/New-PythonProject.ps1`: validate a test folder against python's `naming.folder`; the throw names snake case
      (check: `Invoke-TestFile` on `tests/New-PythonProject.Tests.ps1`, its kebab test re-worded).
- [ ] `pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1`: validate against go's `naming.folder`; the throw names flat case (check:
      `Invoke-TestFile` on `tests/New-GoWorkspace.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1` and `Invoke-BashTest.ps1`: the `tests/<kebab>` comment and lookup follow the
      language case (check: `Invoke-TestFile` on each one's tests).

The three renames, each a plain move on disk with the edits around it in the same step (git stays the user's):

- [ ] `python/tests/catzc-base-repository/` → `python/tests/catzc_base_repository/`, with `python/pyproject.toml` (its member) and
      `pwsh/Catzc.Base.Variants/tests/Get-PathModule.Tests.ps1` (check: `Invoke-TestFile` on `Get-PathModule.Tests.ps1`, `Invoke-PythonTest`
      on the folder).
- [ ] `go/tests/catzc-base-repository/` → `go/tests/catzcbaserepository/`, with its `go.mod` module path and the Go workspace file (check:
      `Invoke-GoTest` on the folder).
- [ ] `python/Catzc.Diagrams/` → `python/catzc_diagrams/`, with its `pyproject.toml` head (`path`, `module`) (check: `Invoke-PythonTest` on
      its tests).
- [ ] The references to `python/Catzc.Diagrams`, one file per step, each checked by `Invoke-TestFile` on its own tests or `Test-Links`:
      `pwsh/Catzc.Base.Globs/configs/file-kinds.yml` with `tests/Get-FileKind.Tests.ps1`; `pwsh/Catzc.Base.Maps/types/MapsHighlight.cs` with
      `tests/types/MapsConfig.Tests.ps1`; `pwsh/Catzc.Base.Slides/types/SlidesConfig.cs`, `configs/slides.yml` with
      `tests/types/SlidesConfig.Tests.ps1`; `pwsh/Catzc.Base.Reports/configs/output-formats.yml`;
      `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`; `python/catzc_diagrams/assets/STYLE.md`;
      `docs/adr/repository/slides-as-markdown.md`; `docs/explanation/index.md`;
      `docs/explanation/vendor/claude/artifact-diagramming-skill.md`; the drawio agents and skills under `.claude/` (check:
      `Test-AgentDefinitions`).
- [ ] `docs/references/`: regenerate the reference pages that name the old folders, never by hand (check: `Test-GeneratedFiles`).

Turn the gate on, last, when it is green:

- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: add `Test-IdiomaticNames` to the `checks` of `powershell`, `python`, `go` and
      `bash` (check: `Test-IdiomaticNames` reports no issue; `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1`).

### 2. The repository normal form

The word model, in `Catzc.Base.Languages` (ADR-AUTO-IDIOM-CLOSEDCASES, -ROUNDTRIP, -ACRONYMISWORD):

- [ ] `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`: give each case a split (name → words) and a join (words → name), and split the
      present `pascal` into the ADR's exact cases: `pascal` (`GetCommandContract`), `pascal-dotted` (`Catzc.Base.Contracts`), `verb-noun`
      (`Get-CommandContract`), beside `kebab`, `snake`, `flat`; a PowerShell test file's `.Tests` is a role suffix outside the case; the
      existing `PathParts.Kebab` is folded in, one living version (check: `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1` and
      `tests/types/PathParts.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: `naming.normal_form: snake`; powershell `folder: [pascal-dotted, kebab]`,
      `file: [verb-noun, pascal-dotted, pascal]`; and per language `function` and `type` cases (powershell `verb-noun` and `pascal-dotted`;
      python `snake` and `pascal`; go `pascal` and `pascal`) (check: `Test-ShippedConfigs`, `Test-IdiomaticNames` still green for
      PowerShell).
- [ ] `pwsh/Catzc.Base.Languages/ConvertTo-NormalName.ps1` and `ConvertFrom-NormalName.ps1`: a name and its language to the normal form, and
      back (check: `Invoke-TestFile` on their tests, the round trip over every tracked function name).

The gate and the repair (ADR-AUTO-IDIOM-HELDBYGATE):

- [ ] `pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs` and `pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1`: judge function and
      type names too (PowerShell from the parsed file, Python `def`/`class`, Go `func`/`type`) and the round trip (check: `Invoke-TestFile`
      on both test files).
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

## Refs

- [idiomatic-names](../../docs/adr/automation/idiomatic-names.md), [command-contracts](../../docs/adr/repository/command-contracts.md),
  [api-contracts](../../docs/adr/repository/api-contracts.md)
- `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`, `types/LanguagesConfig.cs` (`MisnamedPaths`), `configs/languages.yml`
- `pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1`, `Assert-IdiomaticNames.ps1`
