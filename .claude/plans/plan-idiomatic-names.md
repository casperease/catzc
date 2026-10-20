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
      docs/adr/automation/spell-out-names.md,
      docs/adr/automation/python/python-test-artifacts.md,
      docs/adr/automation/go/go-test-artifacts.md,
      docs/adr/repository/command-contracts.md,
    ]
---

# Idiomatic names: every language names its own way, and contracts name in one neutral form

Each source language names its files, folders, functions and types in its own idiom: PowerShell `Get-CommandContract.ps1` in
`Catzc.Base.Contracts/`, Python `get_command_contract` in `catzc_diagrams/`, Go `GetCommandContract` in `catzcbaserepository/`. Under the
idioms sits one language-neutral **repository normal form** of every name, configured once; each language's idiom is a rendering of it, and
the command contracts in `contracts/catzc/0.0.0` are written in it.

## Why its value is high

A name that follows its language's idiom is the one a reader of that language expects, and its tools assume (Python imports a package named
in snake case; Go wants one lowercase word per package directory). A contract that names a command in PowerShell's form binds every other
language to PowerShell's spelling; in the normal form, a contract states the interface once and every language's checker renders its own
name from it
([ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE](../../docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract-checkerperlanguage)).

## Decided (the user, 2026-10-20)

- **The idiom is configuration.** Each language's naming lives in its entry of `pwsh/Catzc.Base.Languages/configs/languages.yml` (`naming:`
  with `folder`, `file`, `exempt`; top-level `naming.exempt_folders`), read by `LanguagesConfig` and judged by
  `LanguagesConfig.MisnamedPaths` (ADR-PRIN-CONFIG).
- **PowerShell is correct as it is; Python and Go are renamed to their idiom.** The tree has three misnamed folders and no misnamed file:
  `python/Catzc.Diagrams/` (snake), `python/tests/catzc-base-repository/` (snake), `go/tests/catzc-base-repository/` (flat).
- **One gate and one assert:** `Test-IdiomaticNames` (a quality gate) and `Assert-IdiomaticNames` (throws), both over the tracked files, in
  `Catzc.Base.QualityGates`. Functions follow that adjust source files to their idiomatic sensible defaults.
- **Function and type names are converted into a language-neutral configured form, the repository normal form**, and that is the form the
  command contracts in `contracts/catzc/0.0.0` use. `0.0.0` is the draft and no `catzc` version is released, so the contracts change in
  place with every caller (ADR-PRIN-ONELIVE).

## Open steps

### 1. Wire it in

The rule first (ADR-REPO-PLANS-DECISIONSBECOMERULES):

- [ ] `docs/adr/automation/spell-out-names.md`: add rule `ADR-AUTO-SPELL-IDIOMATICNAMES`: every language names its files and the folders
      that hold them in its own idiom, stated as a `naming:` entry of the languages config, assets and vendored folders exempt, held by
      `Test-IdiomaticNames`; with its context section (check: `Test-AdrRegistry`, `Build-AdrIndex`, `Test-Links` on the file).
- [ ] `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`: cite `ADR-AUTO-SPELL-IDIOMATICNAMES` in place of `ADR-PRIN-CONFIG` (check:
      `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.QualityGates/tests/Test-IdiomaticNames.Tests.ps1`, `tests/Assert-IdiomaticNames.Tests.ps1` and
      `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1`: re-tag the naming tests `ADR-AUTO-SPELL-IDIOMATICNAMES` (check:
      `Invoke-TestFile` on each).

A test folder maps to its module by its language's naming, no longer by one shared kebab convention:

- [ ] `docs/adr/automation/python/python-test-artifacts.md`: a Python test folder is named for its catzc module in snake case
      (`Catzc.Base.Repository` → `catzc_base_repository`) (check: `Test-Links`, `Test-Spelling` on the file).
- [ ] `docs/adr/automation/go/go-test-artifacts.md`: a Go test module folder is named for its catzc module as one lowercase word
      (`catzcbaserepository`) (check: `Test-Links`, `Test-Spelling` on the file).
- [ ] `pwsh/Catzc.Base.Languages/configs/glossary.yml`: the Python and Go test-folder terms say snake and flat; the Bash term stays kebab
      (check: `Test-Glossary`, `Build-Glossary`).
- [ ] `pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1`: map each test folder to its module by rendering the module name in
      the folder's language naming (from `Get-Config -Config languages`), not by `ToLowerInvariant().Replace('.', '-')`; the throw names the
      expected case (check: `Invoke-TestFile` on its tests).
- [ ] `pwsh/Catzc.Base.Languages/New-PythonProject.ps1`: validate a test folder against python's `naming.folder`; the throw names snake case
      (check: `Invoke-TestFile` on `tests/New-PythonProject.Tests.ps1`, its kebab test re-worded).
- [ ] `pwsh/Catzc.Base.Languages/New-GoWorkspace.ps1`: validate against go's `naming.folder`; the throw names flat case (check:
      `Invoke-TestFile` on `tests/New-GoWorkspace.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1`: the comment and lookup of `tests/<kebab>` follow the language naming (check:
      `Invoke-TestFile` on its tests).

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

- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: add `Test-IdiomaticNames` to the `checks` of `powershell`, `python` and `go`
      (check: `Test-IdiomaticNames` reports no issue; `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1`).

### 2. The repository normal form

The rule first:

- [ ] `docs/adr/automation/spell-out-names.md`: add rule `ADR-AUTO-SPELL-NORMALFORM`: every function, type, parameter and module name has
      one language-neutral normal form, configured once; a language's idiom is a rendering of it, and a name that does not round-trip (idiom
      → normal → the same idiom) is a finding (check: `Test-AdrRegistry`, `Build-AdrIndex`).
- [ ] `docs/adr/repository/command-contracts.md`: the contract language writes command, parameter, type and module names in the normal form;
      the file name is the command's normal form; each language's checker renders its own name before it compares (rules
      `-CONTRACTLANGUAGE`, `-NOPLACEMENTFACTS`, `-CHECKERPERLANGUAGE`, `-ONEREADER`) (check: `Test-AdrRegistry`, `Test-Links`).

The word model, in `Catzc.Base.Languages`:

- [ ] `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`: give each case a split (name → words) and a join (words → name), and refine the
      cases so each one renders exactly: `pascal` (`GetCommandContract`), `pascal-dotted` (`Catzc.Base.Contracts`), `verb-noun`
      (`Get-CommandContract`), `kebab`, `snake`, `flat`; the existing `PathParts.Kebab` is folded in, one living version (check:
      `Invoke-TestFile` on `tests/types/LanguagesConfig.Tests.ps1` and `tests/types/PathParts.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: top-level `naming.normal_form` and, per language, `function` and `type` cases
      (powershell `verb-noun` and `pascal-dotted`; python `snake` and `pascal`; go `pascal` and `pascal`) (check: `Test-ShippedConfigs`).
- [ ] `pwsh/Catzc.Base.Languages/ConvertTo-NormalName.ps1` and `ConvertFrom-NormalName.ps1`: a name and its language to the normal form, and
      back (check: `Invoke-TestFile` on their tests, the round trip over every tracked function name).

The gate and the repair:

- [ ] `pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs` and `pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1`: judge function and
      type names too (PowerShell from the parsed file, Python `def`/`class`, Go `func`/`type`) and the round trip (check: `Invoke-TestFile`
      on both test files).
- [ ] `pwsh/Catzc.Base.QualityGates/Repair-IdiomaticNames.ps1`: moves each misnamed folder or file on disk to its idiomatic name and lists
      every tracked file that references the old path, for one-file-at-a-time edits; `-DryRun` (ADR-PWSH-DRYRUN) (check: `Invoke-TestFile`
      on its tests).

The contracts in the normal form, `contracts/catzc/0.0.0`:

- [ ] `pwsh/Catzc.Base.Contracts/types/ContractCommand.cs` and `ContractParameter.cs`: read names in the normal form (check:
      `Invoke-TestFile` on their type tests).
- [ ] `pwsh/Catzc.Base.Contracts/Get-CommandContract.ps1` and the PowerShell checker under `private/`: render the normal form to `verb-noun`
      before comparing with the file (check: `Invoke-TestFile` on their tests).
- [ ] `contracts/catzc/0.0.0/**/*.command.yml`: each asset renamed and rewritten in the normal form, one file per step (check:
      `Test-Contracts`).
- [ ] `pwsh/Catzc.Base.Contracts/New-CatsCommandLookup.ps1`: the committed lookup keys by the normal form (check: `Invoke-TestFile` on its
      tests, `Test-GeneratedFiles`).

## Open questions

- **The normal form's spelling.** Recommended: lowercase words joined by `-`, namespace segments joined by `.` (`get-command-contract`,
  `repository-root`, `catzc.base.contracts.contract-command[]`); `PathParts.Kebab` already reads `Get-FooBar` this way.
- **Acronyms.** Recommended: an acronym is one ordinary word (`ado` → `Ado`, `ado`, `ado`), as the PowerShell names already spell it; a
  vendor-fixed name (`PSScriptAnalyzerSettings.psd1`) sits in an exempt folder or `exempt`, never in an acronym list.
- **Contract folders.** Recommended: the module folder of a contract path takes the normal form too
  (`contracts/catzc/0.0.0/catzc.base.contracts/`), which also moves the pipeline assets under `Catzc.Azure.DevOps/pipelines/`.
- **Does `cats` take the normal form on the command line** (`cats get-command-contract --repository-root …`), or keep the PowerShell form?

## Refs

- `pwsh/Catzc.Base.Languages/types/LanguageNaming.cs`, `types/LanguagesConfig.cs` (`MisnamedPaths`), `configs/languages.yml`
- `pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1`, `Assert-IdiomaticNames.ps1`
- [command-contracts](../../docs/adr/repository/command-contracts.md), [api-contracts](../../docs/adr/repository/api-contracts.md),
  [spell-out-names](../../docs/adr/automation/spell-out-names.md)
