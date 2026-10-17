---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/.assets/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md
    folder: docs/references/.assets/automation/catzc-base-modulesystem
    name: module-graph-declared-vs-observed-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-CACHE#2
      - ADR-AUTO-DEPM#4
      - ADR-AUTO-TEST#4
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-PESTER#9
---

# out/diagrams/wave-9/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.verify.md

`Verification: Declared graph orders and closes; observed graph is checked (source lens, Catzc.Base.ModuleSystem)`

Every line below was re-read on 2026-10-15 after the comment export; none of the scout's numbers is reused without a re-grep. Several had
moved (`Get-ModuleDependencyConfig.ps1:19` is now `:13`, `Get-ModuleProfile.ps1:50` is now `:45`, `Copy-Automation.ps1:87` is now `:68`,
`Get-FunctionDependency.ps1:68` is now `:63`, `Test-ModuleCycles.ps1:30` is now `:26`). `condense-comments` may move them again, so re-grep
before landing. Paths are relative to `automation/Catzc.Base.ModuleSystem/` unless they start with `automation/` or `docs/`.

## Boxes

| #   | Claim (box)                                                                         | Source (`file:line`)                                                         | Status    |
| --- | ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | --------- |
| B1  | `dependencies.yml` is the declared graph, `groups:` and `modules:` (file)           | `configs/dependencies.yml:1,4`                                               | confirmed |
| B2  | `Get-ModuleDependencyConfig` is private and returns the `modules:` section          | `private/Get-ModuleDependencyConfig.ps1:10,13`                               | confirmed |
| B3  | `Get-ModuleDependencyMap` is private and expands groups to member modules           | `private/Get-ModuleDependencyMap.ps1:14,24-27,55-63`                         | confirmed |
| B4  | `Get-ModuleOrder` is public and topologically sorts the map (Kahn)                  | `Get-ModuleOrder.ps1:47,56,58-93`                                            | confirmed |
| B5  | `Get-TestAutomationTestPaths` is private in `Catzc.Base.QualityGates`               | `automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1` | confirmed |
| B6  | `Get-ModuleDependencyClosure` is private, breadth-first over the map                | `private/Get-ModuleDependencyClosure.ps1:14,21,30-39`                        | confirmed |
| B7  | `Get-FunctionDependency` is public and parses every `.ps1` into an AST              | `Get-FunctionDependency.ps1:17,63`                                           | confirmed |
| B8  | `Get-ModuleDependency` is public and collapses calls to cross-module edges          | `Get-ModuleDependency.ps1:14,34-36`                                          | confirmed |
| B9  | `Get-ModuleDependencyViolations` is private and checks edges against the allow-list | `private/Get-ModuleDependencyViolations.ps1:12,76-86`                        | confirmed |
| B10 | `Test-ModuleCycles` is a quality gate over the observed graph (gate)                | `Test-ModuleCycles.ps1:3,26,56-68`                                           | confirmed |

## Edges (flow: feeds, a result to its caller)

| #   | Edge                                                            | Call site (`file:line`)                                                         | Status    |
| --- | --------------------------------------------------------------- | ------------------------------------------------------------------------------- | --------- |
| E1  | `dependencies.yml` → `Get-ModuleDependencyConfig`               | `private/Get-ModuleDependencyConfig.ps1:13` (`Get-Config -Config dependencies`) | confirmed |
| E2  | `Get-ModuleDependencyConfig` → `Get-ModuleDependencyMap`        | `private/Get-ModuleDependencyMap.ps1:21`                                        | confirmed |
| E3  | `Get-ModuleDependencyMap` → `Get-ModuleOrder`                   | `Get-ModuleOrder.ps1:56`                                                        | confirmed |
| E4  | `Get-ModuleOrder` → `Get-TestAutomationTestPaths`               | `automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1:92` | confirmed |
| E5  | `Get-ModuleDependencyMap` → `Get-ModuleDependencyClosure`       | `private/Get-ModuleDependencyClosure.ps1:21`                                    | confirmed |
| E6  | `Get-FunctionDependency` → `Get-ModuleDependency`               | `Get-ModuleDependency.ps1:31` (when nothing is piped in)                        | confirmed |
| E7  | `Get-ModuleDependency` → `Get-ModuleDependencyViolations`       | `private/Get-ModuleDependencyViolations.ps1:19`                                 | confirmed |
| E8  | `Get-ModuleDependency` → `Test-ModuleCycles`                    | `Test-ModuleCycles.ps1:26`                                                      | confirmed |
| E9  | `Get-ModuleDependencyConfig` → `Get-ModuleDependencyViolations` | `private/Get-ModuleDependencyViolations.ps1:16`                                 | confirmed |

## Bands, markers and the article

| #   | Claim                                                                                                                                      | Source (`file:line`)                                                                                                  | Status       |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------- | ------------ |
| C1  | The map adds group-internal layering and per-module allowed deps, a group expanded to members                                              | `private/Get-ModuleDependencyMap.ps1:36-46,48-69`                                                                     | confirmed    |
| C2  | The map also reads the groups through `Get-ModuleGroupConfig` (cut)                                                                        | `private/Get-ModuleDependencyMap.ps1:20`; `private/Get-ModuleGroupConfig.ps1:14`                                      | confirmed    |
| C3  | `Get-ModuleOrder` throws on a cycle in the declared graph                                                                                  | `Get-ModuleOrder.ps1:95-98`                                                                                           | confirmed    |
| C4  | `Get-TestAutomationTestPaths` catches that throw and falls back to ordinal order, verbose only                                             | `automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1:62-70`                                    | confirmed    |
| C5  | Integrity "fails fast" (ADR-AUTO-DEPM#4); the test-order fallback swallows the declared-graph throw                                        | `docs/adr/automation/controlling-module-dependencies.md:33`; `Get-TestAutomationTestPaths.ps1:65-69`                  | contradicted |
| C6  | The closure closes the profiles: `Get-ModuleProfile` calls it (cut), and `Copy-Automation` and `Test-InIsolation` call `Get-ModuleProfile` | `Get-ModuleProfile.ps1:45`; `Copy-Automation.ps1:68`; `automation/Catzc.Base.QualityGates/Test-InIsolation.ps1:71,74` | confirmed    |
| C7  | `Get-ModuleDependencyViolations` resolves the allow-list itself (its own group expansion), not through the map                             | `private/Get-ModuleDependencyViolations.ps1:24-58`                                                                    | confirmed    |
| C8  | It also checks C# type edges from `Get-CSharpTypeDependency` (module Catzc.Base.TypesSystem; cut)                                          | `private/Get-ModuleDependencyViolations.ps1:90-100`                                                                   | confirmed    |
| C9  | `Test-ModuleDependency` is the gate that reports the violations (cut)                                                                      | `Test-ModuleDependency.ps1:6,29`                                                                                      | confirmed    |
| C10 | The declared graph is acyclic by load-time validation (the `DependenciesConfig` type)                                                      | `docs/adr/automation/controlling-module-dependencies.md:31-34`; `configs/dependencies.yml:1`                          | ADR-only     |
| C11 | Supports: ADR-AUTO-TEST#4, #35, ADR-AUTO-CACHE#2, #4, #5, #6, ADR-PWSH-CACHE#4, ADR-PWSH-PESTER#9, ADR-DSGN-RUNMODE                        | `Get-FunctionDependency.ps1:6,25-29,33,42`; `Test-ModuleCycles.ps1:6`                                                 | confirmed    |
| C12 | No drawn file cites ADR-AUTO-DEPM, the ADR that governs this graph                                                                         | grep `ADR-AUTO-DEPM` over `automation/Catzc.Base.ModuleSystem/**/*.ps1`: no hit                                       | confirmed    |

Counts: 31 claims, 29 confirmed, 1 contradicted, 1 ADR-only.

C10 is ADR-only on this slide because the `DependenciesConfig` type was not re-read for this drawing; the YAML header comment says it
validates at load.

## Corrections

- Every scout line number had moved after the comment export; all the numbers above are new.
- The brief draws `Get-ModuleDependencyViolations ← declared` without naming the source: the code reads `Get-ModuleDependencyConfig`
  directly (`:16`), not the shared map, so the edge leaves `Get-ModuleDependencyConfig`.
- The closure branch is cut to one box, `Get-ModuleDependencyClosure`, as the brief allowed: `Get-ModuleProfile` and `Copy-Automation` would
  take the slide to 12 boxes.

## Drift

- ADR-AUTO-DEPM#4 says integrity "fails fast". `Get-TestAutomationTestPaths.ps1:91-99` catches any `Get-ModuleOrder` throw (a declared-graph
  cycle, or a `dependencies.yml` that fails to load) and continues in ordinal order with only a `Write-Verbose`.
- ADR-AUTO-DEPM governs the graph, but the drawn code never cites it; its comments cite only the cache, test and Pester rules.
- The group expansion of the allow-list is written twice: `Get-ModuleDependencyMap.ps1:24-27,55-63` and
  `Get-ModuleDependencyViolations.ps1:24-58`. Not an ADR drift; flagged for the lead.

## Cut

`Get-ModuleGroupConfig` (the second reader of `dependencies.yml`), `Get-AutomationModules` (the module set), `Get-ModuleProfile` and its
callers `Copy-Automation` and `Test-InIsolation`, `Test-ModuleDependency` (the gate over the violations), `Get-CSharpTypeDependency` (the C#
edge extractor), `Write-QualityGateReport` and the `Get-FunctionDependency` cache. Each is one more box past the cap of 10.
