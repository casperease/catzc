# pwsh/Catzc.Base.Languages/types/GoWorkspaceFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One file New-GoWorkspace renders: the root go.work, or a go/tests/<folder>/go.mod. A result type, so its
properties are PascalCase ([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
The renderer only composes content; Build-RootConfig owns the write
([ADR-REPO-ROOTCFG](/docs/drs/repository/generated-root-configs.md)).
```
