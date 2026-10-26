# Manual test plan — Module system

The module and function dependency graphs against real code, test order, profiles, internal asset dependencies, and the built bundle. Part
of the [manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                |
| --- | ---- | -------------------------------------------------------------------- |
| 1   | L0   | [integrity (shipped config) — DependenciesConfig][c1]                |
| 2   | L0   | [Get-FunctionDependency][c2]                                         |
| 3   | L0   | [Get-ModuleDependency][c3]                                           |
| 4   | L0   | [Module dependencies][c4]                                            |
| 5   | L0   | [integrity (shipped config) — ArtifactsConfig][c5]                   |
| 6   | L1   | [integrity (shipped config + real code) — Test-ModuleDependency][c6] |
| 7   | L1   | [integrity (shipped config) — Get-ModuleGroupConfig][c7]             |
| 8   | L1   | [Test-FunctionDependency][c8]                                        |
| 9   | L1   | [Internal asset dependency coverage (real tree)][c9]                 |
| 10  | L2   | [Function dependencies][c10]                                         |
| 11  | L2   | [Get-ModuleProfile — real profiles.yml][c11]                         |
| 12  | L2   | [Import-Catzc loads a full build (walking skeleton)][c12]            |
| 13  | L2   | [Import-Catzc loads a reduced build][c13]                            |
| 14  | L2   | [Built modules match their source folders][c14]                      |
| 15  | L1   | [New-DynamicManifest against the layout][c15]                        |
| 16  | L1   | [Get-Aspect on the repository][c16]                                  |
| 17  | L1   | [Get-CatzcModule on the repository][c17]                             |
| 18  | L1   | [Get-ModuleOrder on the repository][c18]                             |
| 19  | L1   | [Get-PrivateFunctionFolder][c19]                                     |

[c1]: #1-integrity-shipped-config--dependenciesconfig
[c2]: #2-get-functiondependency
[c3]: #3-get-moduledependency
[c4]: #4-module-dependencies
[c5]: #5-integrity-shipped-config--artifactsconfig
[c6]: #6-integrity-shipped-config--real-code--test-moduledependency
[c7]: #7-integrity-shipped-config--get-modulegroupconfig
[c8]: #8-test-functiondependency
[c9]: #9-internal-asset-dependency-coverage-real-tree
[c10]: #10-function-dependencies
[c11]: #11-get-moduleprofile--real-profilesyml
[c12]: #12-import-catzc-loads-a-full-build-walking-skeleton
[c13]: #13-import-catzc-loads-a-reduced-build
[c14]: #14-built-modules-match-their-source-folders
[c15]: #15-new-dynamicmanifest-against-the-layout
[c16]: #16-get-aspect-on-the-repository
[c17]: #17-get-catzcmodule-on-the-repository
[c18]: #18-get-moduleorder-on-the-repository
[c19]: #19-get-privatefunctionfolder

## Checks

### 1. integrity (shipped config) — DependenciesConfig

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/types/DependenciesConfig.Tests.ps1` (L0), block `integrity (shipped config)`.

**Guards:** the shipped `dependencies.yml` is internally consistent.

**Checks:**

- The shipped `dependencies.yml` loads and validates as a `DependenciesConfig` (acyclic, every target declared). A declared module missing
  on disk is a `Test-ModuleDependency` finding (row 7), not a load check.

### 2. Get-FunctionDependency

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1` (L0), block `Get-FunctionDependency`.

**Guards:** cross-module function dependencies are correctly identified.

**Checks:**

- An edge is flagged `CrossModule` exactly when the caller and target modules differ.

### 3. Get-ModuleDependency

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1` (L0), block `Get-ModuleDependency`.

**Guards:** module dependency edges are extracted correctly.

**Checks:**

- Every edge carries a positive call count.
- Pipeline input yields the same edges as a direct call.

### 4. Module dependencies

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` (L0), block `Module dependencies`.

**Guards:** the module dependency graph has no cycles.

**Checks:**

- The `Test-ModuleCycles` quality gate — a Kahn topological sort over the real cross-module call graph — reports 0 issues: no module sits on
  a cycle.

### 5. integrity (shipped config) — ArtifactsConfig

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1` (L0), block `integrity (shipped config)`.

**Guards:** the shipped `artifacts.yml` (the module-manifest publish targets) is well-formed.

**Checks:**

- The shipped `artifacts.yml` loads through `Get-Config` as an `ArtifactsConfig` with its `ado`, `github`, and `artifactory` targets.

### 6. integrity (shipped config + real code) — Test-ModuleDependency

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1` (L1), block `integrity (shipped config + real code)`.

**Guards:** real code conforms to the declared module dependency graph.

**Checks:**

- The `Test-ModuleDependency` quality gate over the real repo reports 0 issues: every declared module and group member exists on disk, and
  every cross-module function and C# type edge is declared.

### 7. integrity (shipped config) — Get-ModuleGroupConfig

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleGroupConfig.Tests.ps1` (L1), block `integrity (shipped config)`.

**Guards:** the shipped `dependencies.yml` `groups` section is loadable.

**Checks:**

- `Get-ModuleGroupConfig` over the shipped config loads without throwing.

### 8. Test-FunctionDependency

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` (L1), block `Test-FunctionDependency`.

**Guards:** every cross-module function call in the real repo is declared.

**Checks:**

- `Test-FunctionDependency -PassThru` reports no issues: every call resolves and no public function is defined twice.

### 9. Internal asset dependency coverage (real tree)

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1` (L1), block
`Internal asset dependency coverage (real tree)`.

**Guards:** Every internal asset dependency is a literal `Get-CatzcModuleRoot` call and has a real-asset
`ADR-AUTO-ASSETDEP-COVEREDBYREALTEST` test that runs in both test runs (ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY).

### 10. Function dependencies

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1` (L2), block `Function dependencies`.

**Guards:** every non-builtin function call resolves to a defined function.

**Checks:**

- The `Test-FunctionDependency` quality gate over the real repo reports 0 issues: no unresolved function call.

### 11. Get-ModuleProfile — real profiles.yml

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1` (L2), block `Get-ModuleProfile — real profiles.yml`.

**Guards:** Every shipped profile in profiles.yml resolves to a non-empty set of real on-disk modules.

### 12. Import-Catzc loads a full build (walking skeleton)

**Test file:** `pwsh/.internal/tests/Import-Catzc.Tests.ps1` (L2), block `Import-Catzc loads a full build (walking skeleton)`.

**Guards:** `Test-BuildArtifact -Facet Load` over a full build reports 0 issues: it passes Assert-CatzcBundle and loads in a fresh pwsh in
build mode — every module once and from the build root, the types DLL, every shipped config, and InModuleScope.

### 13. Import-Catzc loads a reduced build

**Test file:** `pwsh/.internal/tests/Import-Catzc.Tests.ps1` (L2), block `Import-Catzc loads a reduced build`.

**Guards:** `Test-BuildArtifact -Facet Load` over a reduced build reports 0 issues: it ships the full type set (same hash as the source
tree) and loads exactly its modules in a fresh pwsh, configs and accelerators included.

### 14. Built modules match their source folders

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` (L2), block `Built modules match their source folders`.

**Guards:** `Test-BuildArtifact -Facet Parity` reports 0 issues: every built module exports exactly its source folder's public functions and
carries exactly its private ones.

### 15. New-DynamicManifest against the layout

**Test file:** `pwsh/.internal/tests/New-DynamicManifest.Tests.ps1` (L1), block `New-DynamicManifest against the layout`.

**Guards:** `New-DynamicManifest` loads a .ps1 file exactly from the layout rows that hold functions, and from no other folder
(ADR-AUTO-MODULE-EXISTSBYLAYOUT).

### 16. Get-Aspect on the repository

**Test file:** `pwsh/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1` (L1), block `Get-Aspect on the repository`.

**Guards:** The code track has the five live folders the aspects were written with (ADR-AUTO-MODULE-EXISTSBYLAYOUT).

### 17. Get-CatzcModule on the repository

**Test file:** `pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1` (L1), block `Get-CatzcModule on the repository`.

**Guards:** `Get-CatzcModule` resolves every module folder of the code track, the same set the loader imports, each root under a place of
its track, every language within the track's declared languages, and every file inside the layout (ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE,
ADR-AUTO-MODULE-EXISTSBYLAYOUT, ADR-AUTO-MODULE-LANGUAGESFROMFILES, DDR-MODTYPE-MODULEISPLACEDUNIT).

### 18. Get-ModuleOrder on the repository

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleOrder.Tests.ps1` (L1), block `Get-ModuleOrder on the repository`.

**Guards:** `Get-ModuleOrder` orders every module of the code track once, each after every module it is declared to depend on
(ADR-AUTO-MODULE-TOPOLOGICALORDER).

### 19. Get-PrivateFunctionFolder

**Test file:** `pwsh/.internal/tests/Get-PrivateFunctionFolder.Tests.ps1` (L1), block `Get-PrivateFunctionFolder`.

**Guards:** the loader finds private functions in the folder the shipped languages.yml declares, the same one LanguagesConfig.FolderOf
reads.

**Checks:**

- It reads the same private-function folder as `LanguagesConfig.FolderOf`.
- It throws naming `languages.yml` when the modules root has none, and names the missing row when the powershell layout has no
  private-function role.
