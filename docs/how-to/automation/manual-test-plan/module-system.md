# docs/how-to/automation/manual-test-plan/module-system.md

`Manual test plan — Module system`

The module and function dependency graphs against real code, test order, profiles, internal asset dependencies, and the built bundle. Part
of the [manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                                | FullNameFilter                                     | Guards                                                                                                                                                                              |
| --- | ---- | ---------------------------------------------------------------------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/Catzc.Base.ModuleSystem/tests/types/DependenciesConfig.Tests.ps1              | integrity (shipped config)                         | The shipped `dependencies.yml` is acyclic with all references resolvable.                                                                                                           |
| 2   | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1                | Get-FunctionDependency                             | Cross-module function dependencies are identified correctly.                                                                                                                        |
| 3   | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1                  | Get-ModuleDependency                               | Module dependency edges are extracted with call counts.                                                                                                                             |
| 4   | L0   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1                       | Module dependencies                                | The module dependency graph is acyclic.                                                                                                                                             |
| 5   | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleTestOrder.Tests.ps1                   | Get-ModuleTestOrder (real dependency graph)        | Foundation-first test order is a valid topological sort of the real module dependency graph (every module once).                                                                    |
| 6   | L1   | automation/Catzc.Base.ModuleSystem/tests/Assert-ModuleDependency.Tests.ps1               | integrity (shipped config + real code)             | Real code conforms to the declared module dependency graph (asserts).                                                                                                               |
| 7   | L1   | automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1                 | integrity (shipped config + real code)             | Real code conforms to the declared module dependency graph (boolean).                                                                                                               |
| 8   | L1   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1                 | integrity (shipped config)                         | The shipped `dependencies.yml` `groups` section loads without throwing.                                                                                                             |
| 9   | L1   | automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1               | Test-FunctionDependency                            | Every cross-module function call in the real repo is declared.                                                                                                                      |
| 10  | L1   | automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1 | Internal asset dependency coverage (real tree)     | Every internal asset dependency is a literal `Get-CatzcModuleRoot` call and has a real-asset `ADR-AUTO-ASSETDEP#3` test that runs in both test runs (ADR-AUTO-ASSETDEP#4).          |
| 11  | L2   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1                       | Function dependencies                              | Every non-builtin function call resolves to a defined function.                                                                                                                     |
| 12  | L2   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1                     | Get-ModuleProfile — real profiles.yml              | Every shipped profile in profiles.yml resolves to a non-empty set of real on-disk modules.                                                                                          |
| 13  | L2   | automation/.internal/tests/Import-Catzc.Tests.ps1                                        | Import-Catzc loads a full build (walking skeleton) | A full build passes Assert-CatzcBundle and loads in a fresh pwsh in build mode — every module once and from the build root, the types DLL, every shipped config, and InModuleScope. |
| 14  | L2   | automation/.internal/tests/Import-Catzc.Tests.ps1                                        | Import-Catzc loads a reduced build                 | A reduced build still ships the full type set (same hash as the source tree) and loads exactly its modules in a fresh pwsh, configs and accelerators included.                      |
| 15  | L2   | automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1                | Built modules match their source folders           | Every built module exports exactly its source folder's public functions and carries exactly its private ones.                                                                       |

## Checks

### 1. integrity (shipped config) — DependenciesConfig

**Guards:** the shipped `dependencies.yml` is internally consistent.

**Checks:**

- The shipped `dependencies.yml` loads and validates (acyclic, all references declared, all modules present on disk).

### 2. Get-FunctionDependency

**Guards:** cross-module function dependencies are correctly identified.

**Checks:**

- An edge is flagged `CrossModule` exactly when the caller and target modules differ.

### 3. Get-ModuleDependency

**Guards:** module dependency edges are extracted correctly.

**Checks:**

- Every edge carries a positive call count.
- Pipeline input yields the same edges as a direct call.

### 4. Module dependencies

**Guards:** the module dependency graph has no cycles.

**Checks:**

- A Kahn topological sort over the real cross-module call graph finds no circular dependency.

### 5. Foundation-first module test order

**Guards:** `Get-ModuleTestOrder` topologically sorts the real module dependency graph (`dependencies.yml`) so `Test-Automation` runs module
tests foundation-first.

**Checks:**

- `Get-ModuleTestOrder` returns every on-disk module (`Get-AutomationModules`) exactly once.
- A base module is ordered before a module that depends on it (e.g. `Catzc.Base.Asserts` before `Catzc.Azure.Templates`).

### 6. integrity (shipped config + real code) — Assert-ModuleDependency

**Guards:** real code conforms to the declared module dependency graph.

**Checks:**

- `Assert-ModuleDependency` over the real repo throws nothing — every cross-module edge is declared.

### 7. integrity (shipped config + real code) — Test-ModuleDependency

**Guards:** real code conforms to the declared module dependency graph (boolean form).

**Checks:**

- `Test-ModuleDependency` returns true for the real repo.

### 8. integrity (shipped config) — Get-ModuleGroupConfig

**Guards:** the shipped `dependencies.yml` `groups` section is loadable.

**Checks:**

- `Get-ModuleGroupConfig` over the shipped config loads without throwing.

### 9. Test-FunctionDependency

**Guards:** every cross-module function call in the real repo is declared.

**Checks:**

- `Test-FunctionDependency -PassThru` reports no issues: every call resolves and no public function is defined twice.

### 11. Function dependencies

**Guards:** every non-builtin function call resolves to a defined function.

**Checks:**

- The real-repo call graph has no unresolved function call.
