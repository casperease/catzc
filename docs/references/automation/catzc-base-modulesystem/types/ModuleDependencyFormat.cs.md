---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyFormat.cs.md
    kind: comment-page
    body_sha: "8fe33095e715"
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/types/ModuleDependencyFormat.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.ModuleSystem;`.

```text
Output formats for ConvertTo-ModuleDependencyDiagram. Used as a typed parameter, so the format choice
auto-validates and tab-completes (`-As <TAB>`).

BCL only. Declares its module namespace (file-scoped), per the type loader.
```
