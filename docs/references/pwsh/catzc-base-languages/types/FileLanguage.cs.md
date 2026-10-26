# pwsh/Base.Languages/types/FileLanguage.cs

One file language of the registry (`configs/languages.yml`): the language a tracked file is written in, named by its extension
([DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)). The entry's fields mirror the YAML keys, so the
properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml));
`name` is the entry's YAML key. `LanguagesConfig` validates the entry and builds one, and `Get-FileLanguage` returns them.

## Properties

- **`extensions`** — the extensions that name the language: lowercase, each with its leading dot (for example `.ps1`). Every extension
  belongs to exactly one file language.
- **`no_formatter`** — why the language has no formatter (for example binary files). Null when it has one: an entry carries exactly one of
  `formatter` and `no_formatter`.
- **`checks`** — the quality gates that check a changed file of the language (for example `Test-ScriptAnalyzer`), in the order `Test-Change`
  runs them. Empty when the entry names none.
