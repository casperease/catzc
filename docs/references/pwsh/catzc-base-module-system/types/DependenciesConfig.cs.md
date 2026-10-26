# pwsh/Base.ModuleSystem/types/DependenciesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The declared (ALLOWED) module dependency graph, configs/dependencies.yml
([ADR-AUTO-DEPM](/docs/drs/automation/controlling-module-dependencies.md)). Constructing an instance MAPS and
VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.DependenciesConfig), so
Get-Config -Config dependencies returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

Load-time rules are self-contained — this one file only, no filesystem reads (a declared module that is missing
on disk is a Test-ModuleDependency finding, not load's):
  - only the top-level keys 'groups' (optional map of ModuleGroup) and 'modules' (required map);
  - every group is well-formed (ModuleGroup: closed, no self-dependency, acyclic);
  - each module maps to a list of names (not a single string), never itself, and each target is a declared
    module OR a declared group, so the declared graph is closed;
  - the module graph (edges between declared modules) is acyclic — the first cycle found is reported.
A module absent from `modules:` is unconstrained. Names match case-insensitively, like the PowerShell ordered
dictionary the YAML parses into, so a name declared twice in different case is a violation.
```

## comment:2

Above `public OrderedDictionary modules { get; }`, written with `//`.

```text
Consumer module -> the names it may depend on (string[]: each a group or a module), in declaration
order; read-only.
```

## comment:3

Above `OrderedDictionary adjacency = new...`, written with `//`.

```text
Acyclic over declared MODULE edges only (targets that are themselves declared modules, never a
group or self). Group references are a lower layer and cannot form a module-level cycle.
```
