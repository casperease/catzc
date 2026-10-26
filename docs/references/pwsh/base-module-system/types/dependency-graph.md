# pwsh/Base.ModuleSystem/types/DependencyGraph.cs

The graph helpers behind the declared module dependency graph: reading one node's dependency list from the parsed YAML, and finding a cycle
in a node-to-dependencies adjacency map. [DependenciesConfig](dependencies-config.md) uses them for the module graph and
[ModuleGroup](module-group.md) for each group's internal member graph, so both graphs are read and cycle-checked the same way
([ADR-AUTO-DEPM-GROUPAWAREINTEGRITY](../../../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-groupawareintegrity)).

## ReadNames

Reads one node's dependency list. A null value, a node that is declared and depends on nothing, is the empty list. A list of non-empty names
is the list. A single string, a map or a non-name item is a violation: the `owner` text prefixes the message, and `what` names the expected
entries, for example `names` or `member modules`.

## FindCycle

Returns the first cycle, written as `A -> B -> A`, in a node-to-`string[]` adjacency, visiting nodes and edges in declaration order; null
when the graph is acyclic. Edges to nodes outside the map are ignored.
