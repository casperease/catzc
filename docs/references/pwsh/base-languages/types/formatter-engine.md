# pwsh/Base.Languages/types/FormatterEngine.cs

One formatter engine's settings in the file-language registry (`configs/languages.yml` `formatters:`): the VS Code extension that runs the
same engine in the editor, so Format Document and `Format-Code` agree
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)), and
the repository files whose content decides what the engine writes, so the `Format-Code` result cache is invalidated when one of them
changes. The fields mirror the YAML keys, so the properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml));
`name` is the entry's key.

## Properties

- **`vscode_extension`** — the `publisher.name` id of the VS Code extension that runs the engine (for example `esbenp.prettier-vscode`).
  Null when the editor has none.
