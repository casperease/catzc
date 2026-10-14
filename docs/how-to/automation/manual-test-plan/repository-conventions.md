# docs/how-to/automation/manual-test-plan/repository-conventions.md

`Manual test plan — Repository conventions`

Folder, file, and naming conventions, the repository path helpers, the git index, and the managed-GUID registry. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                           | FullNameFilter                                                    | Guards                                                                                                                                                                                                                                                                                                                                                          |
| --- | ---- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/.internal/tests/Test-FolderConventions.Tests.ps1                         | Folder & file conventions                                         | Conventional folder structure, naming, and no duplicate function exports.                                                                                                                                                                                                                                                                                       |
| 2   | L0   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1                  | Source & test file conventions                                    | One-function-per-file, Verb-Noun naming, repo-wide unique function names.                                                                                                                                                                                                                                                                                       |
| 3   | L1   | automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1                         | Get-TrackedFile (real index)                                      | The real tracked-file universe comes back repo-relative and /-separated, read in-process from the git index.                                                                                                                                                                                                                                                    |
| 4   | L1   | automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1         | Test titles use angle-bracket templates only on data-driven tests | No It/Describe title carries a Pester template token without -ForEach data — the strict-caller name-expansion trap is banned.                                                                                                                                                                                                                                   |
| 5   | L1   | automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1              | Repository guid integrity                                         | Every GUID literal in tracked text is registered in guids.yml, and every registry entry is live (referenced by a tracked file).                                                                                                                                                                                                                                 |
| 6   | L2   | automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1           | Checked-in binaries are stored as binary, not text                | Checked-in binaries have binary EOL handling + explicit `.gitattributes`.                                                                                                                                                                                                                                                                                       |
| 7   | L2   | automation/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1                      | Get-GitTrackedPath (real git)                                     | The in-process git index reader answers exactly what `git ls-files` prints for this repository, whole and pathspec-limited.                                                                                                                                                                                                                                     |
| 8   | L1   | automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1                    | Get-FileLanguage — the real repository                            | Every root folder git tracks a file under is a declared track, each track's file languages are registered, and every live file of a track is in one of its declared file languages (ADR-DSGN-TRACK#3, #6).                                                                                                                                                      |
| 9   | L1   | automation/Catzc.Base.Contracts/tests/Get-Contract.Repository.Tests.ps1             | Get-Contract on the repository                                    | The repository's contracts/ tree lists every version of every unit without error, each asset under contracts/ (ADR-REPO-CONTRACT#2).                                                                                                                                                                                                                            |
| 10  | L1   | automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1 | Get-ContractCheckResults on the repository                        | Checking every asset of every unit's draft returns one result per asset, without error (ADR-REPO-CONTRACT#4).                                                                                                                                                                                                                                                   |
| 11  | L1   | automation/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1                      | Test-Contracts on the repository                                  | The `Test-Contracts` quality gate reports 0 issues: every asset of each unit's draft and the provided assets of every released version folder hold against the real tree, and every released folder matches its `.frozen` record (ADR-REPO-CONTRACT#4, ADR-REPO-CONTRACT#5).                                                                                    |
| 12  | L1   | automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1     | Binding contract assets                                           | One generated test per binding asset — every asset of each unit's draft, and the provided assets of every released version folder — each passing its kind's check; no assets discovers no test (ADR-REPO-CONTRACT#4).                                                                                                                                           |
| 13  | L1   | automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1          | Released contract version folders                                 | One generated test per released version folder (any version but 0.0.0), each unchanged since its release against its `.frozen` record; no released folder discovers no test (ADR-REPO-CONTRACT#5).                                                                                                                                                              |
| 14  | L1   | automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1                             | Get-WorldMap — the real repository                                | Every tracked file lands in exactly one world-map cell, and no cell is a stack violation (ADR-DSGN-TRACK#3, ADR-DSGN-TRACK#6).                                                                                                                                                                                                                                  |
| 15  | L1   | automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1                    | Get-WorldMapHighlight — the real repository                       | An ADR's highlight lights at least one cell, and the zero-argument call returns the working tree's highlight without error.                                                                                                                                                                                                                                     |
| 16  | L1   | automation/Catzc.Base.Maps/tests/Export-WorldMapPdf.Tests.ps1                       | Export-WorldMapPdf — the real repository                          | The real map exports non-empty grid and tree PDFs that parse.                                                                                                                                                                                                                                                                                                   |
| 17  | L1   | automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1                            | Test-WorldMap on the repository                                   | The `Test-WorldMap` quality gate reports 0 issues: no world-map cell is a stack violation, every root folder holding a tracked file but `out/` is a declared track, and every printed label (maps.yml labels, track and file-language names) names a glossary term (ADR-DSGN-TRACK#1, ADR-DSGN-TRACK#3).                                                        |
| 18  | L1   | automation/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1             | Build-ContractReference — generated contract reference            | Each unit's committed contract page, `docs/references/contracts/<unit>.md`, is current with the contract assets (ADR-REPO-CONTRACT#9).                                                                                                                                                                                                                          |
| 19  | L1   | automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1                       | Test-ValueChainMap on the repository                              | The `Test-ValueChainMap` quality gate reports 0 issues: the value-chain map's rows and columns are the value-chain stack and the value-chain concerns AdrsConfig declares, in order, every ADR of adrs.yml sits in at least one cell, and every value_chain_ label of maps.yml names a glossary term (ADR-DSGN-TRACK#14, ADR-DSGN-TRACK#15, ADR-DSGN-TRACK#16). |
| 20  | L1   | automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1                        | Get-ValueChainMap — the real registry                             | Every ADR sits in exactly its value-chain concerns' cells on its ADR domain's value-chain stack row (ADR-DSGN-TRACK#15).                                                                                                                                                                                                                                        |
| 21  | L1   | automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1                  | Get-ValueChainHighlight — the real registry                       | Every ADR's `#1` citation lights its row crossed with its value-chain concerns (ADR-DSGN-TRACK#12).                                                                                                                                                                                                                                                             |
| 22  | L0   | automation/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1        | Parameter consistency of the public functions                     | One parameter name carries one type across the public functions, apart from the names parameter-consistency.yml exempts with a reason; an exemption that no longer conflicts is reported (ADR-PWSH-PARAM).                                                                                                                                                      |

## Checks

### 1. Folder & file conventions

**Guards:** the repository's conventional folder structure for automation, naming, and a single global function namespace.

**Checks:**

- Module subdirectories are limited to the conventional names (`private`, `tests`, `assets`, `types`, `configs`).
- `*.Tests.ps1` files live only under `tests/`.
- No public function name is exported by more than one module.
- `configs/` entries are flat kebab-case `.yml` (never `.yaml`, never nested); no legacy `assets/config/` or `assets/test/`.

### 2. Source & test file conventions

**Guards:** one-function-per-file, Verb-Noun naming, and a repo-wide unique function namespace.

**Checks:**

- The scan found >100 source and test files (guards against a silent no-op).
- Every source file is Verb-Noun, defines exactly one top-level function, and that function matches the file name.
- Every test file is `Verb-Noun.Tests.ps1`.
- Every function name (public and private) is defined in exactly one file across the repo.

### 5. Repository guid integrity

**Guards:** the managed-GUID registry and the tracked tree agree in both directions.

**Checks:**

- Every GUID literal found in tracked text (`Get-RepositoryGuids` over the scan universe) is registered in
  `Catzc.Base.QualityGates/configs/guids.yml`.
- Every registry entry is live — at least one tracked file references its guid.

### 6. Checked-in binaries are stored as binary, not text

**Guards:** checked-in binaries are stored without EOL conversion.

**Checks:**

- Checked-in binaries are found (guards against a vacuous pass).
- Each is stored with no EOL conversion (git index `-text`) and carries an explicit binary `.gitattributes` rule.

**Prerequisite:** git.
