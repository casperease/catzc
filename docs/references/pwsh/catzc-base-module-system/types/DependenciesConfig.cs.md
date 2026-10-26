# pwsh/Base.ModuleSystem/types/DependenciesConfig.cs

The typed record for `dependencies.yml`, the declared (allowed) module dependency graph
([ADR-AUTO-DEPM](../../../../drs/automation/controlling-module-dependencies.md)). It is registered in
`Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config dependencies` returns it. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one `ArgumentException`. The rules are
self-contained: this one file only, with no file system reads. A declared module that is missing on disk is a `Test-ModuleDependency`
finding, not a load failure.

- only the top-level keys `groups` (an optional map of [ModuleGroup](ModuleGroup.cs.md)) and `modules` (required) are allowed;
- every group is well-formed: closed, no self-dependency, acyclic;
- each module maps to a list of names, never a single string and never itself, and each target is a declared module or a declared group, so
  the declared graph is closed;
- the module graph is acyclic, and the first cycle found is reported. Only edges between declared modules are walked. Group references are a
  layer below and cannot form a module-level cycle.

A module absent from `modules:` is unconstrained. Names match case-insensitively, like the PowerShell ordered dictionary the YAML parses
into, so a name declared twice in different case is a violation. The list helpers are shared with groups through
[DependencyGraph](DependencyGraph.cs.md).

## Properties

- **`groups`** — group name to its `ModuleGroup`, in declaration order, read-only; empty when the file declares no groups.
- **`modules`** — consumer module to the names it may depend on (`string[]`, each a group or a module), in declaration order, read-only.
