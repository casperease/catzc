---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyFormat.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4026714be5ef"
---

# automation/Catzc.Base.ModuleSystem/types/ModuleDependencyFormat.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.ModuleSystem;`, written with `//`.

```text
Output formats for ConvertTo-ModuleDependencyDiagram. Used as a typed parameter, so the format choice
auto-validates and tab-completes (`-As <TAB>`).

BCL only. Declares its module namespace (file-scoped), per the type loader.
```
