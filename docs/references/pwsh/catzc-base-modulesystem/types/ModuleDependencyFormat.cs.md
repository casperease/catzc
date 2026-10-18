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
