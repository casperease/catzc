# docs/how-to/automation/manual-test-plan/repository-conventions.md

`Manual test plan — Repository conventions`

Folder, file, and naming conventions, the repository path helpers, the git index, and the managed-GUID registry. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                   | FullNameFilter                                                    | Guards                                                                                                                          |
| --- | ---- | --------------------------------------------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/.internal/tests/Test-FolderConventions.Tests.ps1                 | Folder & file conventions                                         | Conventional folder structure, naming, and no duplicate function exports.                                                       |
| 2   | L0   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1          | Source & test file conventions                                    | One-function-per-file, Verb-Noun naming, repo-wide unique function names.                                                       |
| 3   | L0   | automation/Catzc.Base.Repository/tests/Get-RepositoryRoot.Tests.ps1         | Get-RepositoryRoot                                                | The repository root resolves and exists on disk.                                                                                |
| 4   | L0   | automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1       | Get-RepositoryFolder                                              | Repository folder paths join to root and exist.                                                                                 |
| 5   | L0   | automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1         | Get-RepositoryFile                                                | Repository file paths join to root and exist.                                                                                   |
| 6   | L1   | automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1                 | Get-TrackedFile (real index)                                      | The real tracked-file universe comes back repo-relative and /-separated, read in-process from the git index.                    |
| 7   | L1   | automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1 | Test titles use angle-bracket templates only on data-driven tests | No It/Describe title carries a Pester template token without -ForEach data — the strict-caller name-expansion trap is banned.   |
| 8   | L1   | automation/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1      | Repository guid integrity                                         | Every GUID literal in tracked text is registered in guids.yml, and every registry entry is live (referenced by a tracked file). |
| 9   | L2   | automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1   | Checked-in binaries are stored as binary, not text                | Checked-in binaries have binary EOL handling + explicit `.gitattributes`.                                                       |
| 10  | L2   | automation/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1              | Get-GitTrackedPath (real git)                                     | The in-process git index reader answers exactly what `git ls-files` prints for this repository, whole and pathspec-limited.     |

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

### 3. Get-RepositoryRoot

**Guards:** the repository root resolves and exists.

**Checks:**

- Returns the repo root (matching `$env:RepositoryRoot`); the path exists.

### 4. Get-RepositoryFolder

**Guards:** repository folder paths resolve and exist.

**Checks:**

- Joins a relative path to the root; a known folder resolves to an existing path.

### 5. Get-RepositoryFile

**Guards:** repository file paths resolve and exist.

**Checks:**

- Joins a relative path to the root; a known file resolves to an existing path.

### 8. Repository guid integrity

**Guards:** the managed-GUID registry and the tracked tree agree in both directions.

**Checks:**

- Every GUID literal found in tracked text (`Get-RepositoryGuids` over the scan universe) is registered in
  `Catzc.Base.QualityGates/configs/guids.yml`.
- Every registry entry is live — at least one tracked file references its guid.

### 9. Checked-in binaries are stored as binary, not text

**Guards:** checked-in binaries are stored without EOL conversion.

**Checks:**

- Checked-in binaries are found (guards against a vacuous pass).
- Each is stored with no EOL conversion (git index `-text`) and carries an explicit binary `.gitattributes` rule.

**Prerequisite:** git.
