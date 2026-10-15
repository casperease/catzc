---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-ModuleDependencyEdges.ps1.md
    kind: comment-page
    body_sha: dff810848432
---

# automation/Catzc.Base.ModuleSystem/Get-ModuleDependencyEdges.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
By default returns the ACTUAL cross-module call edges derived from the code (via Get-ModuleDependency)
— each carrying its call count and the calling functions. With -Declared, returns the ALLOWED edges
from configs/dependencies.yml instead: each module's permitted dependencies (a target may be a GROUP
name), plus each group's internal member->member layering.

Pipe the result to ConvertTo-ModuleDependencyDiagram to render JSON / YAML / Markdown / PlantUML.
```
