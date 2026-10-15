---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyEdge.cs.md
    kind: reference
    body_sha: "338d1e58cb6f"
    adrs: []
---

# automation/Catzc.Base.ModuleSystem/types/ModuleDependencyEdge.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A single module-to-module dependency edge, typed for rendering to JSON / YAML / Markdown / PlantUML.

Kind is "actual" — a real cross-module call edge (from Get-ModuleDependency; CallCount and Functions
populated) — or "declared" — an allowed edge from configs/dependencies.yml (CallCount 0, Functions
empty; To may be a GROUP name rather than a module). Produced by Get-ModuleDependencyEdges and rendered
by ConvertTo-ModuleDependencyDiagram.

BCL only; declares its module namespace (file-scoped), per the type loader. PascalCase (a result
shape, not a YAML-config mirror).
```
