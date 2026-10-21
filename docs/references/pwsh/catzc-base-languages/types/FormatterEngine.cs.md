# pwsh/Catzc.Base.Languages/types/FormatterEngine.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One formatter engine's settings in the file-language registry (configs/languages.yml `engines:`): the VS Code
extension that runs the same engine in the editor, so Format Document and Format-Code agree
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)), and the repository files whose
content decides what the engine writes, so Format-Code's result cache is invalidated when one of them changes. The
fields mirror the YAML keys, so the properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); `name` is the entry's key.
```

## comment:2

Above `public string vscode_extension { get; }`, written with `//`.

```text
The publisher.name id of the VS Code extension that runs the engine (e.g. esbenp.prettier-vscode). Null when the
editor has none.
```
