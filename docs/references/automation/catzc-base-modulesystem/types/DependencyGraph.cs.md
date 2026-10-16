---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fc366001814c
    adrs:
      - ADR-AUTO-DEPM#4
---

# automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The graph helpers behind the declared module dependency graph (configs/dependencies.yml): reading one
node's dependency list from the parsed YAML, and finding a cycle in a node -> dependencies adjacency map.
Shared by DependenciesConfig (the module graph) and ModuleGroup (each group's internal member graph), so
both graphs read and cycle-check the same way
([ADR-AUTO-DEPM#4](/docs/adr/automation/controlling-module-dependencies.md#rule-adr-auto-depm4)).
```

## comment:2

Above `public static string[] ReadNames(object value, string owner, string what,...`, written with `//`.

```text
Reads one node's dependency list: null (declared, depends on nothing) is empty; a list of non-empty
names is the list; a single string, a map, or a non-name item is a violation ('owner' prefixes it, and
'what' names the expected entries, e.g. "names" or "member modules").
```

## comment:3

Above `public static string FindCycle(OrderedDictionary adjacency)`, written with `//`.

```text
The first cycle (as "A -> B -> A") in a node -> string[] adjacency, visiting nodes and edges in
declaration order; null when the graph is acyclic. Edges to nodes outside the map are ignored.
```
