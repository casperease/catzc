---
catzc:
  derived:
    path: docs/how-to/automation/manual-test-plan/module-system.md
    kind: how-to
    language: markdown
    track: docs
    body_sha: e7725350ff34
    adrs:
      - ADR-AUTO-ASSETDEP#{3,4}
    links:
      - docs/how-to/automation/manual-test-plan.md
---

# Manual test plan — Module system

The module and function dependency graphs against real code, test order, profiles, internal asset dependencies, and the built bundle. Part
of the [manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                                | FullNameFilter                                     | Guards                                                                                                                                                                                                                                         |
| --- | ---- | ---------------------------------------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/Catzc.Base.ModuleSystem/tests/types/DependenciesConfig.Tests.ps1              | integrity (shipped config)                         | The shipped `dependencies.yml` loads through `DependenciesConfig`: acyclic, with every target declared.                                                                                                                                        |
| 2   | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1                | Get-FunctionDependency                             | Cross-module function dependencies are identified correctly.                                                                                                                                                                                   |
| 3   | L0   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1                  | Get-ModuleDependency                               | Module dependency edges are extracted with call counts.                                                                                                                                                                                        |
| 4   | L0   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1                       | Module dependencies                                | The real module call graph is acyclic: `Test-ModuleCycles` reports 0 issues.                                                                                                                                                                   |
| 5   | L0   | automation/Catzc.Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1                 | integrity (shipped config)                         | The shipped `artifacts.yml` loads through `ArtifactsConfig`.                                                                                                                                                                                   |
| 6   | L1   | automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1                 | integrity (shipped config + real code)             | Real code conforms to the declared module dependency graph: `Test-ModuleDependency` reports 0 issues.                                                                                                                                          |
| 7   | L1   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1                 | integrity (shipped config)                         | The shipped `dependencies.yml` `groups` section loads without throwing.                                                                                                                                                                        |
| 8   | L1   | automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1               | Test-FunctionDependency                            | Every cross-module function call in the real repo is declared.                                                                                                                                                                                 |
| 9   | L1   | automation/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1 | Internal asset dependency coverage (real tree)     | Every internal asset dependency is a literal `Get-CatzcModuleRoot` call and has a real-asset `ADR-AUTO-ASSETDEP#3` test that runs in both test runs (ADR-AUTO-ASSETDEP#4).                                                                     |
| 10  | L2   | automation/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1                       | Function dependencies                              | Every non-builtin function call resolves to a defined function: `Test-FunctionDependency` reports 0 issues.                                                                                                                                    |
| 11  | L2   | automation/Catzc.Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1                     | Get-ModuleProfile — real profiles.yml              | Every shipped profile in profiles.yml resolves to a non-empty set of real on-disk modules.                                                                                                                                                     |
| 12  | L2   | automation/.internal/tests/Import-Catzc.Tests.ps1                                        | Import-Catzc loads a full build (walking skeleton) | `Test-BuildArtifact -Facet Load` over a full build reports 0 issues: it passes Assert-CatzcBundle and loads in a fresh pwsh in build mode — every module once and from the build root, the types DLL, every shipped config, and InModuleScope. |
| 13  | L2   | automation/.internal/tests/Import-Catzc.Tests.ps1                                        | Import-Catzc loads a reduced build                 | `Test-BuildArtifact -Facet Load` over a reduced build reports 0 issues: it ships the full type set (same hash as the source tree) and loads exactly its modules in a fresh pwsh, configs and accelerators included.                            |
| 14  | L2   | automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1                | Built modules match their source folders           | `Test-BuildArtifact -Facet Parity` reports 0 issues: every built module exports exactly its source folder's public functions and carries exactly its private ones.                                                                             |

## Checks

### 1. integrity (shipped config) — DependenciesConfig

**Guards:** the shipped `dependencies.yml` is internally consistent.

**Checks:**

- The shipped `dependencies.yml` loads and validates as a `DependenciesConfig` (acyclic, every target declared). A declared module missing
  on disk is a `Test-ModuleDependency` finding (row 7), not a load check.

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

- The `Test-ModuleCycles` quality gate — a Kahn topological sort over the real cross-module call graph — reports 0 issues: no module sits on
  a cycle.

### 5. integrity (shipped config) — ArtifactsConfig

**Guards:** the shipped `artifacts.yml` (the module-manifest publish targets) is well-formed.

**Checks:**

- The shipped `artifacts.yml` loads through `Get-Config` as an `ArtifactsConfig` with its `ado`, `github`, and `artifactory` targets.

### 6. integrity (shipped config + real code) — Test-ModuleDependency

**Guards:** real code conforms to the declared module dependency graph.

**Checks:**

- The `Test-ModuleDependency` quality gate over the real repo reports 0 issues: every declared module and group member exists on disk, and
  every cross-module function and C# type edge is declared.

### 7. integrity (shipped config) — Get-ModuleGroupConfig

**Guards:** the shipped `dependencies.yml` `groups` section is loadable.

**Checks:**

- `Get-ModuleGroupConfig` over the shipped config loads without throwing.

### 8. Test-FunctionDependency

**Guards:** every cross-module function call in the real repo is declared.

**Checks:**

- `Test-FunctionDependency -PassThru` reports no issues: every call resolves and no public function is defined twice.

### 10. Function dependencies

**Guards:** every non-builtin function call resolves to a defined function.

**Checks:**

- The `Test-FunctionDependency` quality gate over the real repo reports 0 issues: no unresolved function call.
