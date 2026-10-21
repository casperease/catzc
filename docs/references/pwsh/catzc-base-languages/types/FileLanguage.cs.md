# pwsh/Catzc.Base.Languages/types/FileLanguage.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One file language of the registry (configs/languages.yml): the language a tracked file is written in, named by its
extension ([DDR-TRACK-FILELANGUAGE](/docs/drs/design/tracks.md#rule-ddr-track-filelanguage)). The entry's fields mirror the YAML
keys, so the properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); `name` is the entry's
YAML key. LanguagesConfig validates the entry and builds one; Get-FileLanguage returns them.
```

## comment:2

Above `public IReadOnlyList<string> extensions { get; }`, written with `//`.

```text
The extensions that name the language: lowercase, each with its leading dot (e.g. .ps1). Every extension
belongs to exactly one file language.
```

## comment:3

Above `public string no_formatter { get; }`, written with `//`.

```text
Why the language has no formatter (e.g. binary files). Null when it has one: an entry carries exactly one of
formatter and no_formatter.
```

## comment:4

Above `public IReadOnlyList<string> checks { get; }`, written with `//`.

```text
The quality gates that check a changed file of the language (e.g. Test-ScriptAnalyzer), in the order Test-Change
runs them. Empty when the entry names none.
```
