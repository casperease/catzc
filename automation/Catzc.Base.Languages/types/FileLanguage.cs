// One file language of the registry (configs/languages.yml): the language a tracked file is written in, named by its
// extension ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). The entry's fields mirror the YAML
// keys, so the properties are snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `name` is the entry's
// YAML key. LanguagesConfig validates the entry and builds one; Get-FileLanguage returns them.

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class FileLanguage
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The file language's kebab-case name: its key in the `languages` map (e.g. powershell, pipeline-yaml).
    public string name { get; }

    // The extensions that name the language: lowercase, each with its leading dot (e.g. .ps1). Every extension
    // belongs to exactly one file language.
    public IReadOnlyList<string> extensions { get; }

    // The formatter engine Format-Code runs over the language's files (e.g. prettier). Null when it has none.
    public string formatter { get; }

    // Why the language has no formatter (e.g. binary files). Null when it has one: an entry carries exactly one of
    // formatter and no_formatter.
    public string no_formatter { get; }

    // The VS Code language id of the language's files (e.g. azure-pipelines); its own name unless the entry states one.
    public string vscode_language { get; }

    // The language's ADR folder under docs/adr/ (e.g. pwsh). Null when it has none.
    public string adr_folder { get; }

    public FileLanguage(string name, string[] extensions, string formatter, string noFormatter, string vscodeLanguage, string adrFolder)
    {
        this.name = name;
        this.extensions = extensions == null ? Array.Empty<string>() : (string[])extensions.Clone();
        this.formatter = formatter;
        no_formatter = noFormatter;
        vscode_language = vscodeLanguage ?? name;
        adr_folder = adrFolder;
    }
}
