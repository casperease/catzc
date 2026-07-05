# Manual test plan — integrity assertions

This plan enumerates every **integrity** check in the Pester suite — the tests that read the _real repository contents_ (shipped
`azure.yml`/`network.yml`/`tools.yml`/`ado.yml`/`dependencies.yml`, real templates, the module/type/function graph, checked-in binaries,
file & folder conventions). Logic tests (hermetic, run on mocks and fixtures) are out of scope.

Each numbered section below is one integrity check. **Section _N_ corresponds to row _N_** in the index table — the row gives the
`Test file` and `FullNameFilter` you paste into the single-check command to trigger that one assertion by hand.

The whole plan is just one command (`Test-Automation -Category Integrity -Level 2`) decomposed so a tester can run, and reason about, each
check on its own.

## How to run a check

Two ways — a whole group, or one check at a time.

**Run a group (the supported path):**

```powershell
. ./importer.ps1
Test-Automation -Category Integrity -Level 2                   # every integrity check (the whole plan)
Test-Automation -Category Integrity -Modules Catzc.Azure        # one module's integrity checks
Test-Automation -Category Integrity -Level 2 -Output Detailed  # one line per assertion
```

**Run one check (precise):** take the `Test file` and `FullNameFilter` from the row and filter Pester to it:

```powershell
. ./importer.ps1
Import-Module ./automation/.vendor/Pester -Force
Invoke-Pester -Path <Test file> -FullNameFilter '*<FullNameFilter>*' -Output Detailed
```

A check **passes** when its assertions are green. A few L2 checks shell out to a tool (git, PSScriptAnalyzer, cspell, markdownlint-cli2) and
**self-skip** when that tool is absent — a skip is not a failure (see the end-of-run skip report).

## Index

| #   | Tier | Test file                                                                       | FullNameFilter                                                       | Guards                                                                                                                            |
| --- | ---- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/.internal/tests/Test-FolderConventions.Tests.ps1                     | Folder & file conventions                                            | Conventional folder structure, naming, and no duplicate function exports.                                                         |
| 2   | L0   | automation/.internal/tests/Import-CSharpTypes.Tests.ps1                         | shipped C# types                                                     | Every shipped C# type compiles and resolves into the process.                                                                     |
| 3   | L0   | automation/.internal/tests/Import-CSharpTypes.Tests.ps1                         | DictionaryRecord (shared cross-module base)                          | The shared cross-module `DictionaryRecord` base and its dict-view work.                                                           |
| 4   | L0   | automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1                 | Config conventions                                                   | Every `Assert-*Config` maps to a shipped config and rejects malformed input.                                                      |
| 5   | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                         | discovery + raw default                                              | Raw (unvalidated) configs load as ordered dictionaries from disk.                                                                 |
| 6   | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                         | convention validation (owner scope)                                  | Convention-validated configs load and pass their owner's validator.                                                               |
| 7   | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                         | registry self-validation (shipped configs.yml)                       | The shipped `configs.yml` registry itself validates and loads.                                                                    |
| 8   | L0   | automation/Catzc.Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1      | integrity (real repo)                                                | All shipped C# type sources parse without syntax errors.                                                                          |
| 9   | L0   | automation/Catzc.Base.ModuleSystem/tests/Assert-DependenciesConfig.Tests.ps1    | integrity (shipped config)                                           | The shipped `dependencies.yml` is acyclic with all references resolvable.                                                         |
| 10  | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1       | Get-FunctionDependency                                               | Cross-module function dependencies are identified correctly.                                                                      |
| 11  | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1         | Get-ModuleDependency                                                 | Module dependency edges are extracted with call counts.                                                                           |
| 12  | L0   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1              | Source & test file conventions                                       | One-function-per-file, Verb-Noun naming, repo-wide unique function names.                                                         |
| 13  | L0   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1              | Module dependencies                                                  | The module dependency graph is acyclic.                                                                                           |
| 14  | L0   | automation/Catzc.Base.Repository/tests/Get-RepositoryRoot.Tests.ps1             | Get-RepositoryRoot                                                   | The repository root resolves and exists on disk.                                                                                  |
| 15  | L0   | automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1           | Get-RepositoryFolder                                                 | Repository folder paths join to root and exist.                                                                                   |
| 16  | L0   | automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1             | Get-RepositoryFile                                                   | Repository file paths join to root and exist.                                                                                     |
| 17  | L0   | automation/Catzc.Tooling.Core/tests/Assert-ToolsConfig.Tests.ps1                | integrity (shipped tools.yml)                                        | The shipped `tools.yml` conforms to the validator (snake_case keys).                                                              |
| 18  | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1              | shipped tools.yml (generic invariant)                                | The `tools.yml` dependency graph is acyclic and install order is valid.                                                           |
| 19  | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1                    | asset dependencies                                                   | Required tooling asset files are present.                                                                                         |
| 20  | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1                    | structural validation                                                | Every `tools.yml` entry has required fields and a valid install method.                                                           |
| 21  | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1                    | Install/Uninstall function coverage                                  | Every tool has matching `Install-*` and `Uninstall-*` functions.                                                                  |
| 22  | L0   | automation/Catzc.Azure/tests/Assert-AzureConfig.Tests.ps1                       | integrity (shipped azure.yml)                                        | The shipped `azure.yml` passes schema + cross-record validation.                                                                  |
| 23  | L0   | automation/Catzc.Azure/tests/Assert-NetworkConfig.Tests.ps1                     | integrity (shipped network.yml)                                      | The shipped `network.yml` has valid CIDRs and env completeness.                                                                   |
| 24  | L0   | automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1                  | scanning real repo YAML                                              | The repo's ADO YAML is discoverable, parseable, and classifiable.                                                                 |
| 25  | L0   | automation/Catzc.Azure.DevOps/tests/Assert-AdoConfig.Tests.ps1                  | passes for the shipped ado.yml                                       | The shipped `ado.yml` passes validation.                                                                                          |
| 26  | L0   | automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1          | Shipped template integrity                                           | Every shipped template is discoverable, well-formed, and structurally valid.                                                      |
| 27  | L0   | automation/Catzc.Azure.Templates/tests/Get-Config.Integrity.Tests.ps1           | Shipped asset integrity                                              | Templates reference only defined environments and customers.                                                                      |
| 28  | L1   | automation/Catzc.Base.ModuleSystem/tests/Assert-ModuleDependency.Tests.ps1      | integrity (shipped config + real code)                               | Real code conforms to the declared module dependency graph (asserts).                                                             |
| 29  | L1   | automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1        | integrity (shipped config + real code)                               | Real code conforms to the declared module dependency graph (boolean).                                                             |
| 30  | L1   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1        | integrity (shipped config)                                           | The shipped `dependencies.yml` `groups` section loads without throwing.                                                           |
| 31  | L1   | automation/Catzc.Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1         | never plans the live combined build for deletion (real repo, DryRun) | The live combined types DLL is never marked for deletion.                                                                         |
| 32  | L1   | automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1      | Test-FunctionDependency                                              | Every cross-module function call in the real repo is declared.                                                                    |
| 33  | L1   | automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1                  | exclude filtering                                                    | The `.git` directory is excluded from YAML discovery.                                                                             |
| 34  | L1   | automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1      | Manual test plan covers every integrity check                        | This document lists every integrity check, with no stale rows.                                                                    |
| 35  | L2   | automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1                        | PSScriptAnalyzer                                                     | All module code passes PSScriptAnalyzer (style + custom rules).                                                                   |
| 36  | L2   | automation/.internal/tests/Import-CSharpTypes.Tests.ps1                         | combined types assembly is committed and current                     | The committed combined types DLL matches current sources (no drift).                                                              |
| 37  | L2   | automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1       | Checked-in binaries are stored as binary, not text                   | Checked-in binaries have binary EOL handling + explicit `.gitattributes`.                                                         |
| 38  | L2   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1              | Function dependencies                                                | Every non-builtin function call resolves to a defined function.                                                                   |
| 39  | L2   | automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1                | Repository spelling integrity                                        | All in-scope repository content passes spell-check.                                                                               |
| 40  | L2   | automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1            | Repository markdown integrity                                        | All in-scope repository markdown passes markdownlint.                                                                             |
| 41  | L0   | automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1               | asset dependencies                                                   | The vendored .NET install scripts (dotnet-install.ps1/.sh) ship with the Toolchain module.                                        |
| 42  | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleTestOrder.Tests.ps1          | Get-ModuleTestOrder (real dependency graph)                          | Foundation-first test order is a valid topological sort of the real module dependency graph (every module once).                  |
| 43  | L2   | automation/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1  | Build-TerminologyDictionary — real registry                          | The checked-in terminology dictionary matches the registry (no drift) and is lower-cased, unique, ordinal-sorted.                 |
| 44  | L2   | automation/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1             | Terminology registry integrity                                       | The shipped terminology registry passes every gate: no drift, no orphans, every entry justified.                                  |
| 45  | L2   | automation/.internal/tests/Get-DynamicManifestContent.Tests.ps1                 | Get-DynamicManifestContent is formatter-stable                       | A generated module manifest is byte-stable under the repo formatter (no re-format churn).                                         |
| 46  | L2   | automation/Catzc.Base.Docs/tests/Build-Readme.Tests.ps1                         | Build-Readme — real readme.yml                                       | Every generated README's source exists, the pattern covers every automation module, and mapped READMEs stay gitignored.           |
| 47  | L2   | automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1                | Generated README copy-ins are gitignored and untracked               | Every generated README copy-in is gitignored and untracked in git (a derived artifact, never committed).                          |
| 48  | L2   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1            | Get-ModuleProfile — real profiles.yml                                | Every shipped profile in profiles.yml resolves to a non-empty set of real on-disk modules.                                        |
| 49  | L1   | automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1      | Build-EnglishDictionary — committed dictionary drift guard           | The committed English word list matches its stamp and the pinned cspell version (no drift).                                       |
| 50  | L1   | automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1         | SpellingOracle.CoinedFragments (shipped dictionary)                  | The spelling oracle recognizes real words and flags coined fragments against the shipped dictionary.                              |
| 51  | L0   | automation/Catzc.Base.Variants/tests/Assert-VariantsConfig.Tests.ps1            | integrity (shipped variants.yml)                                     | The shipped variants.yml validates — ado_naming is a known order and have_customers is false, all, or a valid customer-name list. |
| 52  | L0   | automation/Catzc.Azure/tests/Assert-CustomerConfig.Tests.ps1                    | integrity (shipped customer.yml)                                     | The shipped customer.yml validates — customer keys/shortcodes are well-formed, unique, and non-colliding.                         |
| 53  | L0   | automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1                    | against a real shipped config                                        | `Get-ConfigValue` resolves a real shipped config subtree end-to-end through the live `Get-Config`.                                |
| 54  | L1   | automation/Catzc.Base.QualityGates/tests/Build-ScriptAnalyzerSettings.Tests.ps1 | Build-ScriptAnalyzerSettings — real config                           | The importer-kept root PSScriptAnalyzerSettings.psd1 matches the authored source (no drift) and parses as a settings hashtable.   |
| 55  | L0   | automation/Catzc.Base.Vendor/tests/Assert-VendorConfig.Tests.ps1                | integrity (shipped vendor.yml)                                       | The shipped vendor.yml passes Assert-VendorConfig (known keys, a present source, an absolute source URL).                         |
| 56  | L2   | automation/Catzc.Base.ModuleSystem/tests/New-Importer.Tests.ps1                 | New-Importer — importer.ps1 drift guard                              | The committed importer.ps1 equals New-Importer output and its parameter set matches the Invoke-Importer overlay (no drift).       |

## L0 · integrity

### 1. Folder & file conventions

**Guards:** the repository's conventional folder structure for automation, naming, and a single global function namespace.

**Checks:**

- Module subdirectories are limited to the conventional names (`private`, `tests`, `assets`, `types`, `configs`).
- `*.Tests.ps1` files live only under `tests/`.
- No public function name is exported by more than one module.
- `configs/` entries are flat kebab-case `.yml` (never `.yaml`, never nested); no legacy `assets/config/` or `assets/test/`.

### 2. shipped C# types

**Guards:** every shipped automation C# type compiles and resolves into the process.

**Checks:**

- At least one C# type source exists (guards against a vacuous pass).
- Every shipped type's fully-qualified name (`<module>.<typename>`) resolves after import.

### 3. DictionaryRecord (shared cross-module base)

**Guards:** the shared cross-module `Catzc.Base.Utils`-era `DictionaryRecord` base and its dictionary view.

**Checks:**

- A derived record (`BicepTemplate`) inherits `DictionaryRecord`.
- `Contains`, the indexer, `Keys`, and `ToHashtable` expose only non-null data properties (not base members).
- A derived type in another module can call the inherited extraction helpers.

### 4. Config conventions

**Guards:** every config validator maps to a shipped config, and each rejects malformed input.

**Checks:**

- Every private `Assert-*Config` validator maps to a `configs/<name>.yml` (no orphans).
- Each validated shipped config (`ado`, `azure`, `network`, `dependencies`) rejects a malformed file through `Get-Config`.

### 5. discovery + raw default

**Guards:** raw (unvalidated) configs load correctly from disk.

**Checks:**

- A config with no validator is discovered and loaded as an ordered dictionary.

### 6. convention validation (owner scope)

**Guards:** convention-validated configs load and pass their owner-module validator.

**Checks:**

- A real config with a private `Assert-*Config` (e.g. `dependencies.yml`) loads and passes validation.

### 7. registry self-validation (shipped configs.yml)

**Guards:** the shipped `configs.yml` registry itself validates.

**Checks:**

- The live registry validator runs against the shipped `configs.yml` and loads without error.

### 8. integrity (real repo) — Get-CSharpTypeDependency

**Guards:** all shipped C# type sources are parseable.

**Checks:**

- Scanning the shipped `types/*.cs` across modules produces no parse error.

### 9. integrity (shipped config) — Assert-DependenciesConfig

**Guards:** the shipped `dependencies.yml` is internally consistent.

**Checks:**

- The shipped `dependencies.yml` loads and validates (acyclic, all references declared, all modules present on disk).

### 10. Get-FunctionDependency

**Guards:** cross-module function dependencies are correctly identified.

**Checks:**

- An edge is flagged `CrossModule` exactly when the caller and target modules differ.

### 11. Get-ModuleDependency

**Guards:** module dependency edges are extracted correctly.

**Checks:**

- Every edge carries a positive call count.
- Pipeline input yields the same edges as a direct call.

### 12. Source & test file conventions

**Guards:** one-function-per-file, Verb-Noun naming, and a repo-wide unique function namespace.

**Checks:**

- The scan found >100 source and test files (guards against a silent no-op).
- Every source file is Verb-Noun, defines exactly one top-level function, and that function matches the file name.
- Every test file is `Verb-Noun.Tests.ps1`.
- Every function name (public and private) is defined in exactly one file across the repo.

### 13. Module dependencies

**Guards:** the module dependency graph has no cycles.

**Checks:**

- A Kahn topological sort over the real cross-module call graph finds no circular dependency.

### 14. Get-RepositoryRoot

**Guards:** the repository root resolves and exists.

**Checks:**

- Returns the repo root (matching `$env:RepositoryRoot`); the path exists.

### 15. Get-RepositoryFolder

**Guards:** repository folder paths resolve and exist.

**Checks:**

- Joins a relative path to the root; a known folder resolves to an existing path.

### 16. Get-RepositoryFile

**Guards:** repository file paths resolve and exist.

**Checks:**

- Joins a relative path to the root; a known file resolves to an existing path.

### 17. integrity (shipped tools.yml) — Assert-ToolsConfig

**Guards:** the shipped `tools.yml` conforms to its validator.

**Checks:**

- `Assert-ToolsConfig` accepts the shipped `tools.yml` (all keys snake_case).

### 18. shipped tools.yml (generic invariant)

**Guards:** the `tools.yml` dependency graph is acyclic and install order is valid.

**Checks:**

- `Get-ToolInstallOrder` returns each tool exactly once over the full shipped set.
- Every dependency precedes its dependent in the returned order.

### 19. asset dependencies

**Guards:** the tooling's required asset files are present.

**Checks:**

- `configs/tools.yml` and the `dotnet-install.ps1`/`.sh` scripts exist.

### 20. structural validation

**Guards:** every `tools.yml` entry is well-formed.

**Checks:**

- At least one tool is defined; each has `version`, `command`, `version_command`, `version_pattern`.
- Each `version_pattern` has a named `(?<ver>…)` group; each tool declares an install mechanism.
- Every `DependsOn` reference points to a defined tool.

### 21. Install/Uninstall function coverage

**Guards:** every tool has install and uninstall functions.

**Checks:**

- Each tool has an `Install-<suffix>` and an `Uninstall-<suffix>` function available.

### 22. integrity (shipped azure.yml)

**Guards:** the shipped `azure.yml` is schema-valid and internally consistent.

**Checks:**

- `Assert-AzureConfig` accepts the shipped `azure.yml` (tenants, subscriptions, environments, customers).

### 23. integrity (shipped network.yml)

**Guards:** the shipped `network.yml` is valid and complete relative to `azure.yml`.

**Checks:**

- `Assert-NetworkConfig` accepts the shipped `network.yml` (valid CIDRs, every standard env present).

### 24. scanning real repo YAML

**Guards:** the repo's Azure Pipelines YAML is discoverable and parseable.

**Checks:**

- `Get-AdoYamlFiles` returns results with the expected properties; `RelativePath` uses forward slashes.
- Pipeline/template files classify correctly; no file produces a parse error.

### 25. passes for the shipped ado.yml

**Guards:** the shipped `ado.yml` is valid.

**Checks:**

- `Assert-AdoConfig` accepts the shipped `ado.yml` (organization, project, tenant).

### 26. Shipped template integrity

**Guards:** every shipped bicep template is discoverable and structurally valid.

**Checks:**

- Discovery finds the templates; at least one exists.
- Every template declares a `short_name` in `options.yml`; `short_name`s are globally unique.
- Every template has a configuration slot and passes `Assert-BicepTemplate` (no build).

### 27. Shipped asset integrity

**Guards:** cross-asset referential integrity across `azure.yml`, `network.yml`, and templates.

**Checks:**

- `azure.yml` and `network.yml` pass their validators.
- Every template slot references environments and customers defined in `azure.yml`.

## L1 · integrity

### 28. integrity (shipped config + real code) — Assert-ModuleDependency

**Guards:** real code conforms to the declared module dependency graph.

**Checks:**

- `Assert-ModuleDependency` over the real repo throws nothing — every cross-module edge is declared.

### 29. integrity (shipped config + real code) — Test-ModuleDependency

**Guards:** real code conforms to the declared module dependency graph (boolean form).

**Checks:**

- `Test-ModuleDependency` returns true for the real repo.

### 30. integrity (shipped config) — Get-ModuleGroupConfig

**Guards:** the shipped `dependencies.yml` `groups` section is loadable.

**Checks:**

- `Get-ModuleGroupConfig` over the shipped config loads without throwing.

### 31. never plans the live combined build for deletion (real repo, DryRun)

**Guards:** the type-cache janitor never deletes the live combined types DLL.

**Checks:**

- `Clear-ModuleTypeCache -DryRun` over the real repo never plans the current-hash DLL for deletion.

### 32. Test-FunctionDependency

**Guards:** every cross-module function call in the real repo is declared.

**Checks:**

- `Test-FunctionDependency` returns a boolean, and returns true when all dependencies are satisfied.

### 33. exclude filtering

**Guards:** the `.git` directory is excluded from YAML discovery.

**Checks:**

- `Get-AdoYamlFiles -Path <repo>` returns no file under `.git/`.

### 34. Manual test plan covers every integrity check

**Guards:** this document stays in sync with the suite (the drift guard for this plan).

**Checks:**

- It AST-discovers every `integrity`-tagged `Describe`/`Context`/`It` in the suite.
- Every discovered `(test file, block)` pair has a row in the index table above.
- The number of index rows equals the number of discovered integrity blocks (no stale or duplicate rows).

## L2 · integrity

### 35. PSScriptAnalyzer

**Guards:** all PowerShell module code meets the analyzer rule set.

**Checks:**

- The file set includes >50 module files (guards against a no-op).
- No PSScriptAnalyzer violation across module roots, `private/`, and `tests/` (built-in + custom rules).

**Prerequisite:** PSScriptAnalyzer (vendored).

### 36. combined types assembly is committed and current

**Guards:** the committed combined types DLL reflects current source.

**Checks:**

- `automation/.compiled/` has no pending git changes after import (drift guard).
- Exactly one `Catzc.Types.*.dll` exists and its hash matches the current sources.

**Prerequisite:** git.

### 37. Checked-in binaries are stored as binary, not text

**Guards:** checked-in binaries are stored without EOL conversion.

**Checks:**

- Checked-in binaries are found (guards against a vacuous pass).
- Each is stored with no EOL conversion (git index `-text`) and carries an explicit binary `.gitattributes` rule.

**Prerequisite:** git.

### 38. Function dependencies

**Guards:** every non-builtin function call resolves to a defined function.

**Checks:**

- The real-repo call graph has no unresolved function call.

### 39. Repository spelling integrity

**Guards:** all in-scope repository content is spell-clean.

**Checks:**

- Real `cspell` over the default content scope (excludes `out/`, `docs/notes/`, vendored) reports no misspelling.

**Prerequisite:** cspell.

### 40. Repository markdown integrity

**Guards:** all in-scope repository markdown is lint-clean.

**Checks:**

- Real `markdownlint-cli2` over the default content scope reports no violation.

**Prerequisite:** markdownlint-cli2.

### 41. Asset dependencies (Toolchain)

**Guards:** the vendored .NET install scripts ship with the `Catzc.Tooling.Toolchain` module.

**Checks:**

- `dotnet-install.ps1` and `dotnet-install.sh` exist under `Catzc.Tooling.Toolchain/assets/scripts/`.

### 42. Foundation-first module test order

**Guards:** `Get-ModuleTestOrder` topologically sorts the real module dependency graph (`dependencies.yml`) so `Test-Automation` runs module
tests foundation-first.

**Checks:**

- `Get-ModuleTestOrder` returns every on-disk module (`Get-AutomationModules`) exactly once.
- A base module is ordered before a module that depends on it (e.g. `Catzc.Base.Asserts` before `Catzc.Azure.Templates`).

### 43. Build-TerminologyDictionary — real registry

**Guards:** the checked-in terminology dictionaries reflect the authored registry.

**Checks:**

- The generated `.cspell/<category>.txt` lists (gitignored, regenerated on import) match what the registry generates (no drift).
- Each generated dictionary is lower-cased, de-duplicated, and ordinal-sorted (deterministic).

### 44. Terminology registry integrity

**Guards:** the shipped terminology registry passes every terminology gate.

**Checks:**

- `Test-Terminology` over the shipped `terminology.yml` throws nothing: no drift, no orphans, and every entry is justified (a category and a
  meaning, with an expansion for each abbreviation).

### 45. Get-DynamicManifestContent is formatter-stable

**Guards:** a generated module manifest's canonical form equals what the repo formatter produces, so a published (immutable, versioned)
manifest never churns when it is later re-formatted.

**Checks:**

- `Invoke-Formatter` over a `Get-DynamicManifestContent` result (using the shipped `PSScriptAnalyzerSettings.psd1`) leaves it byte-for-byte
  unchanged.

**Prerequisite:** PSScriptAnalyzer (vendored).
