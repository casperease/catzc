---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyEdge.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7a82bbac5334"
---

# automation/Catzc.Base.ModuleSystem/types/ModuleDependencyEdge.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A single module-to-module dependency edge, typed for rendering to JSON / YAML / Markdown / PlantUML.

Kind is "actual" — a real cross-module call edge (from Get-ModuleDependency; CallCount and Functions
populated) — or "declared" — an allowed edge from configs/dependencies.yml (CallCount 0, Functions
empty; To may be a GROUP name rather than a module). Produced by Get-ModuleDependencyEdges and rendered
by ConvertTo-ModuleDependencyDiagram.

BCL only; declares its module namespace (file-scoped), per the type loader. PascalCase (a result
shape, not a YAML-config mirror).
```
