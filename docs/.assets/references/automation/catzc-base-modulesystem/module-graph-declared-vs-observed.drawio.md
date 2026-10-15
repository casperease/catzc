---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.md
    kind: asset-description
    body_sha: "50e69fa2bb87"
    adrs:
      - ADR-AUTO-CACHE#2
      - ADR-AUTO-DEPM#4
      - ADR-AUTO-TEST#{4,35}
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-PESTER#9
    links:
      - docs/.assets/references/automation/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.png
---

# Declared graph orders and closes; observed graph is checked: the diagram described

```text
A 1588 x 642 diagram, read left to right through two bands, top to bottom.
Glyphs: 4 code units, 5 private helpers, 1 gate, 1 file, 1 catzc module frame; 9 flow edges; 9 markers.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](module-graph-declared-vs-observed.drawio.png) draws from the source of the `Catzc.Base.ModuleSystem`
module. The module's reference article embeds it and gives the responsibility in prose.

## At a glance

Cats keeps two module graphs. The declared graph is what `dependencies.yml` allows: one shared map built from it orders the modules for
testing and closes a set of modules over their dependencies. The observed graph is what the code really calls, read from the parsed code of
every function. The observed graph is checked twice: for cycles on its own, and against the declared allow-list.

## Walkthrough

1. **`dependencies.yml`** declares the allowed graph in two sections: `groups:`, named sets of modules with their own internal layering, and
   `modules:`, what each consumer may depend on. `Get-ModuleDependencyConfig` returns the `modules:` section through `Get-Config`.
2. **`Get-ModuleDependencyMap`** builds one map, module to the set of modules it is declared to depend on. It adds each group's internal
   layering, then each module's allowed dependencies, expanding a dependency on a group to every member of the group. It also reads the
   groups through `Get-ModuleGroupConfig`, which is cut from the drawing.
3. **`Get-ModuleTestOrder`** sorts the map topologically, foundation first, with an ordinal tie-break so the order is stable. A cycle in the
   declared graph throws.
4. **`Get-TestAutomationTestPaths`**, in `Catzc.Base.QualityGates`, orders the test folders by that sort. When the sort throws, it catches
   the error and falls back to ordinal module order, writing only a verbose line (see the last section).
5. **`Get-ModuleDependencyClosure`** walks the same map breadth-first from a set of seed modules and returns the seeds plus everything they
   depend on. `Get-ModuleProfile` calls it to close a profile, and `Copy-Automation` and `Test-InIsolation` take their module sets from
   `Get-ModuleProfile`; those three are cut from the drawing.
6. **`Get-FunctionDependency`** parses every `.ps1` file of every module under the modules root (dot folders, tests and `assets` excluded)
   into an AST and lists each call from one function to another that the repository defines. Its result is cached (ADR-AUTO-CACHE#2, #4, #5,
   #6).
7. **`Get-ModuleDependency`** collapses those calls into unique cross-module edges, `From` → `To`, with a call count.
8. **`Get-ModuleDependencyViolations`** checks every observed edge from a constrained module against its allow-list, which it resolves
   itself straight from `Get-ModuleDependencyConfig` and the groups, not through the shared map. It also checks that every declared module
   exists on disk, and applies the same allow-list to cross-module C# type references. The `Test-ModuleDependency` gate reports what it
   finds (ADR-AUTO-TEST#35).
9. **`Test-ModuleCycles`** is a quality gate over the observed edges alone: a topological pass that reports every module on, or called from,
   a cycle (ADR-AUTO-TEST#35).

## Reading path

Start at `dependencies.yml` in the DECLARED GRAPH band and follow the flow right through `Get-ModuleDependencyConfig` and
`Get-ModuleDependencyMap` to `Get-ModuleTestOrder`, and on into `Get-TestAutomationTestPaths` inside the `Catzc.Base.QualityGates` frame. A
second edge drops from the map and runs right to `Get-ModuleDependencyClosure` on the band's lower row. In the OBSERVED GRAPH band, start at
`Get-FunctionDependency` and follow the flow right to `Get-ModuleDependency`, which feeds `Get-ModuleDependencyViolations` to its right and,
through a drop below it, the `Test-ModuleCycles` gate. The one edge between the bands leaves `Get-ModuleDependencyConfig`, runs right in the
gap between the bands and enters `Get-ModuleDependencyViolations` from above.

## Glyphs

| Glyph                            | Kind           | Band                                            | Marker |
| -------------------------------- | -------------- | ----------------------------------------------- | ------ |
| `dependencies.yml`               | file           | DECLARED GRAPH                                  | 1      |
| `Get-ModuleDependencyConfig`     | private helper | DECLARED GRAPH                                  | —      |
| `Get-ModuleDependencyMap`        | private helper | DECLARED GRAPH                                  | 2      |
| `Get-ModuleTestOrder`            | code unit      | DECLARED GRAPH                                  | 3      |
| `Get-TestAutomationTestPaths`    | private helper | DECLARED GRAPH, `Catzc.Base.QualityGates` frame | 4      |
| `Get-ModuleDependencyClosure`    | private helper | DECLARED GRAPH                                  | 5      |
| `Get-FunctionDependency`         | code unit      | OBSERVED GRAPH                                  | 6      |
| `Get-ModuleDependency`           | code unit      | OBSERVED GRAPH                                  | 7      |
| `Get-ModuleDependencyViolations` | private helper | OBSERVED GRAPH                                  | 8      |
| `Test-ModuleCycles`              | gate           | OBSERVED GRAPH                                  | 9      |

The slide shows `Get-ModuleDependencyViolations` elided as `Get-Module…Violations`. `Get-TestAutomationTestPaths` is private to
`Catzc.Base.QualityGates`, drawn inside that module's slate frame. Private helpers have a darker fill than the code units.

## Edges

Every edge is a flow edge meaning "feeds": the result of the function at the tail goes to its caller at the head. Each is backed by the
caller's call site.

| From                         | To                               | Call site                                                         |
| ---------------------------- | -------------------------------- | ----------------------------------------------------------------- |
| `dependencies.yml`           | `Get-ModuleDependencyConfig`     | `private/Get-ModuleDependencyConfig.ps1` (`Get-Config`)           |
| `Get-ModuleDependencyConfig` | `Get-ModuleDependencyMap`        | `private/Get-ModuleDependencyMap.ps1`                             |
| `Get-ModuleDependencyMap`    | `Get-ModuleTestOrder`            | `Get-ModuleTestOrder.ps1`                                         |
| `Get-ModuleTestOrder`        | `Get-TestAutomationTestPaths`    | `Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1` |
| `Get-ModuleDependencyMap`    | `Get-ModuleDependencyClosure`    | `private/Get-ModuleDependencyClosure.ps1`                         |
| `Get-FunctionDependency`     | `Get-ModuleDependency`           | `Get-ModuleDependency.ps1`, when nothing is piped in              |
| `Get-ModuleDependency`       | `Get-ModuleDependencyViolations` | `private/Get-ModuleDependencyViolations.ps1`                      |
| `Get-ModuleDependency`       | `Test-ModuleCycles`              | `Test-ModuleCycles.ps1`                                           |
| `Get-ModuleDependencyConfig` | `Get-ModuleDependencyViolations` | `private/Get-ModuleDependencyViolations.ps1`                      |

The edges to `Get-ModuleDependencyClosure`, `Test-ModuleCycles` and `Get-ModuleDependencyViolations` (from the declared side) bend through
port points; each is one edge.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

- code unit
- private helper
- gate
- file
- catzc module
- flow: feeds (a result to its caller)
- marker: a Walkthrough step

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AUTO-TEST#4 and #35, ADR-AUTO-CACHE#2, #4, #5 and #6,
ADR-PWSH-CACHE#4, ADR-PWSH-PESTER#9 and ADR-DSGN-RUNMODE: the rules the drawn code cites, almost all from `Get-FunctionDependency`.
Source-lens slides carry no minimaps.

## Where the code and the ADR differ

- **The test-order fallback swallows a fail-fast error.** ADR-AUTO-DEPM#4 says the integrity of the declared graph fails fast.
  `Get-TestAutomationTestPaths` catches any throw from `Get-ModuleTestOrder`, a cycle or a `dependencies.yml` that does not load, and
  carries on in ordinal module order with only a verbose line. The ADR's load-time validation should stop a cyclic declaration first; that
  part is ADR-only on this slide.
- **The drawn code never cites ADR-AUTO-DEPM**, the ADR that governs this graph, so it is missing from the Supports chips.
- The allow-list's group expansion is written twice, in `Get-ModuleDependencyMap` and in `Get-ModuleDependencyViolations`. That is not an
  ADR drift, but the two must stay in step.
