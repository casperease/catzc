# Catzc.Base.ModuleSystem

The module-system introspection module: the one place the platform turns to reason about its own shape — which modules and functions exist
on disk, what the module-to-module and function-to-function dependency edges actually are, and whether those edges — together with the
cross-module C# type edges computed by [Catzc.Base.TypesSystem](catzc-base-typessystem.md) — conform to the group-aware declared graph in
`dependencies.yml`. The dependency integrity check is the mechanical guard that keeps the layering honest (see
[open-closed-architecture](../../adr/automation/open-closed-architecture.md) and
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)); generating the repository's `importer.ps1` entry point completes
the module's concern. The native C# type system itself — the compiled-assembly cache and the cross-module type-reference scanner — lives in
[Catzc.Base.TypesSystem](catzc-base-typessystem.md).

## Domains

| Domain   | Area       | Name                                                                       |
| -------- | ---------- | -------------------------------------------------------------------------- |
| domain:1 | introspect | [Function enumeration](#domain1--function-enumeration)                     |
| domain:2 | graph      | [Dependency graph and integrity](#domain2--dependency-graph-and-integrity) |
| domain:3 | importer   | [Importer generation](#domain3--importer-generation)                       |

### domain:1 — Function enumeration

The primitive that answers "what functions exist": the full set of PowerShell functions the automation modules define, and — with
`-NotUsedInternally` — which of them are never called by another. It builds on the on-disk module list that
[Catzc.Base.TypesSystem](catzc-base-typessystem.md)'s `Get-AutomationModules` provides, and the dependency-edge computation in domain 2
traverses this function set to find call sites.

### domain:2 — Dependency graph and integrity

Computing the actual dependency edges — module-to-module through PowerShell call-site analysis and function-to-function through call-graph
traversal from a named root — then asserting those edges, together with the cross-module C# type edges that
[Catzc.Base.TypesSystem](catzc-base-typessystem.md) computes, against the declared graph in `dependencies.yml`. The declared graph is
group-aware: its `groups:` section names sets of on-disk modules each with an internal member-to-member DAG; its `modules:` section lists,
per consumer, the allowed targets as group names (loose: any member) or specific module names (tight). Integrity validation resolves each
declared target to a member set, takes the union, and tests that every actual edge falls within it; it also tests that the global module
graph and each group's internal DAG are acyclic. The config this domain owns — `dependencies.yml` — is the platform's single declared
layering contract.

### domain:3 — Importer generation

Generating a repository's `importer.ps1` — the dot-sourced entry point that loads the toolset. `New-Importer` reads the parameter block of
the `Invoke-Importer` overlay and renders `importer.ps1` around a fixed template, so the committed entry point can never drift from the load
sequence it delegates to (a drift test regenerates and compares). It scaffolds into any repository root that already carries the toolset, so
the same generator serves this repository and a vendored copy of it. The vendored modules themselves are managed by
[Catzc.Base.Vendor](catzc-base-vendor.md).

## What the module does

The module is the platform's self-knowledge layer. Its three domains build in sequence: domain 1 enumerates the functions the modules
define, domain 2 computes and asserts what the code actually depends on, and domain 3 generates the `importer.ps1` entry point that loads
them.

The dependency graph half of domain 2 deserves explicit explanation because `dependencies.yml` carries a `groups` schema. The file has two
top-level sections. `groups:` is a map where each key is a group name and each value is a map of on-disk module names to the list of other
members they are allowed to depend on — the group's internal member-to-member DAG. A group is a concept, not a disk module: it names a set
of real modules and declares the layering among them. `modules:` lists, per consumer module, the targets it may depend on; each target is
either a group name — loose, meaning any member of that group — or a specific module name — tight, meaning only that exact module. The
integrity check resolves each declared target to a member set, unions the sets for a given consumer, and verifies that every actual edge
from that consumer falls within the resolved allow-set. It simultaneously checks that the global module graph is acyclic and that each
group's internal DAG is acyclic; a cycle in either breaks the layering guarantee.

The `Base` group is the primary instance of this schema. It holds the cluster of small, focused libraries that replaced the old
`Catzc.Base.Utils` monolith: `Catzc.Base.Asserts`, `Catzc.Base.Repository`, `Catzc.Base.Environment`, `Catzc.Base.Objects`,
`Catzc.Base.Writers`, `Catzc.Base.Config`, `Catzc.Base.Execution`, `Catzc.Base.Files`, `Catzc.Base.TypesSystem`, `Catzc.Base.ModuleSystem`,
and `Catzc.Base.QualityGates`. `Catzc.Base.ModuleSystem` is itself a member of the group; its declared intra-group dependencies are
`Catzc.Base.TypesSystem`, `Catzc.Base.Repository`, `Catzc.Base.Config`, `Catzc.Base.Files`, `Catzc.Base.Writers`, and `Catzc.Base.Asserts`.
A domain module such as `Catzc.Azure` or `Catzc.Tooling.Core` declares `[Base]` in its `modules:` entry, which permits an edge to any of
those eleven members without naming each individually.

The integrity check is the mechanical evidence that the [open-closed-architecture](../../adr/automation/open-closed-architecture.md) rules
hold: extending the platform means adding new files, and the dependency graph is what proves no addition created a layering violation. The
cross-module C# type edges that PowerShell call-site analysis cannot see are computed by
[Catzc.Base.TypesSystem](catzc-base-typessystem.md)'s `Get-CSharpTypeDependency` (see
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)) and folded into this module's integrity assertion, completing the
edge set it runs against.

## Division

The module's public functions and configuration file, sorted into the domains above.

| Domain                                    | Function                     |
| ----------------------------------------- | ---------------------------- |
| domain:1 — Function enumeration           | `Get-AutomationFunctions`    |
| domain:2 — Dependency graph and integrity | `Get-ModuleDependency`       |
|                                           | `Get-FunctionDependency`     |
|                                           | `Get-FunctionDependencyTree` |
|                                           | `Assert-ModuleDependency`    |
|                                           | `Test-ModuleDependency`      |
|                                           | `Test-FunctionDependency`    |
| config                                    | `dependencies.yml`           |
| domain:3 — Importer generation            | `New-Importer`               |
