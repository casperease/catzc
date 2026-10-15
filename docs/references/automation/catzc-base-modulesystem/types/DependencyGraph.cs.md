---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
    kind: comment-page
    body_sha: fe3511802c2f
    adrs:
      - ADR-AUTO-DEPM#4
---

# automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The graph helpers behind the declared module dependency graph (configs/dependencies.yml): reading one
node's dependency list from the parsed YAML, and finding a cycle in a node -> dependencies adjacency map.
Shared by DependenciesConfig (the module graph) and ModuleGroup (each group's internal member graph), so
both graphs read and cycle-check the same way
([ADR-AUTO-DEPM#4](/docs/adr/automation/controlling-module-dependencies.md#rule-adr-auto-depm4)).
```

## comment:2

Above `public static string[] ReadNames(object value, string owner, string what,...`.

```text
Reads one node's dependency list: null (declared, depends on nothing) is empty; a list of non-empty
names is the list; a single string, a map, or a non-name item is a violation ('owner' prefixes it, and
'what' names the expected entries, e.g. "names" or "member modules").
```

## comment:3

Above `public static string FindCycle(OrderedDictionary adjacency)`.

```text
The first cycle (as "A -> B -> A") in a node -> string[] adjacency, visiting nodes and edges in
declaration order; null when the graph is acyclic. Edges to nodes outside the map are ignored.
```
