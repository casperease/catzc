---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "98b2238f79a4"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#6
      - ADR-PRIN-CONFIG#{1,2,4}
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.Languages/types/LanguagesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The file-language registry (configs/languages.yml): every file language the repository's tracked files are written
in, each named by its extensions ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)), with the
formatter engine that formats it and its ADR folder. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.Languages.LanguagesConfig), so Get-Config -Config languages returns this typed record; Get-FileLanguage
and Format-Code read it. Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Formatting is configured, not programmed
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)): an entry names the
formatter ENGINE that formats its files, one of FormatterEngines below, and Format-Code runs that engine. A language
with nothing to format states why in 'no_formatter' instead
([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)), so every language
carries exactly one of the two and a gap is a visible, reviewed entry.

The sensible defaults are declared here, once
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted 'languages' is no
file language, an omitted 'adr_folder' is none, and an omitted 'checks' is no quality gate.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only 'engines' and 'languages' at the top; only 'extensions', 'formatter', 'no_formatter', 'vscode_language',
    'adr_folder' and 'checks' in a language entry; only 'vscode_extension' and 'settings' in an engine entry — an
    unknown key (a typo) fails at load;
  - 'checks' is a list of quality-gate command names (Test-<Noun>, e.g. Test-ScriptAnalyzer), each at most once: the
    gates Test-Change runs over a changed file of the language;
  - an engine entry's key is one of FormatterEngines, its 'vscode_extension' a publisher.name extension id, and its
    'settings' a list of '/'-separated repository-relative files (no '.' or '..' segment);
  - 'vscode_language' (default: the language's own name) is a VS Code language id;
  - a language name is kebab-case;
  - 'extensions' is a non-empty list; each extension starts with its leading dot, is lowercase letters and digits
    after it (e.g. .ps1), and belongs to exactly one file language (an extension claimed twice is rejected);
  - exactly one of 'formatter' (an engine in FormatterEngines) and 'no_formatter' (a non-empty reason);
  - 'adr_folder' is a '/'-separated folder under docs/adr/, no leading or trailing slash, no '.' or '..' segment.
```

## comment:2

Above `private static readonly string[] Engines = { "prettier", "gofmt", "ruff",...`, written with `//`.

```text
The formatter engines a language may name: one Format-Code adapter each. A new engine is new mechanism — its
adapter and its name here land together
([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
```

## comment:3

Above `public IReadOnlyDictionary<string, FormatterEngine> engines { get; }`, written with `//`.

```text
The engines' own settings, by engine name: the VS Code extension that runs the same engine in the editor. An
engine the file does not list has no editor formatter.
```

## comment:4

Above `public IReadOnlyDictionary<string, string> EditorFormatters()`, written with `//`.

```text
The editor formatter of every language whose engine names a VS Code extension, keyed by the language's VS Code
language id: what the editor's Format Document runs, the same engine Format-Code runs
([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).
```

## comment:5

Above `public static string ExtensionOf(string path)`, written with `//`.

```text
The extension of a file path, lowercase with its leading dot, or null when it has none. A dotfile whose only dot
is its first character (.gitkeep, .editorconfig) has no extension.
```

## comment:6

Above `string vscodeLanguage = name;`, written with `//`.

```text
The VS Code language id defaults to the language's own name; an entry states it only where the editor's id
differs (pipeline YAML is VS Code's azure-pipelines language).
```
