# pwsh/Catzc.Base.Languages/types/BclConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class BclConfig : Catzc.Base.Objects.DictionaryRecord`, written with `//`.

```text
The BCL language's own config: the one build configuration and platform every non-vendored .sln and .csproj declares, and every
dotnet call builds (ADR-BCL-TYPES-DEBUGANYCPU).
```
