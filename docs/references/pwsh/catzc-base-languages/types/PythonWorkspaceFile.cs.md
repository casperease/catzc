# pwsh/Catzc.Base.Languages/types/PythonWorkspaceFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One file New-PythonProject renders: the uv workspace root <root>/pyproject.toml, or a member
<root>/tests/<folder>/pyproject.toml. A result type, so its properties are PascalCase
([ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)). The renderer only composes
content; Build-RootConfig owns the write ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```
