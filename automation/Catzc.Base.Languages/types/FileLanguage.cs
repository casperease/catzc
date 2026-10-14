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
    // The file language's kebab-case name: its key in the `languages` map (e.g. powershell, pipeline-yaml).
    public string name { get; }

    // The extensions that name the language: lowercase, each with its leading dot (e.g. .ps1). Every extension
    // belongs to exactly one file language.
    public IReadOnlyList<string> extensions { get; }

    // The repository command that formats the language's files (e.g. Format-Markdown). Null when it has none.
    public string formatter { get; }

    // The language's ADR folder under docs/adr/ (e.g. automation/powershell). Null when it has none.
    public string adr_folder { get; }

    public FileLanguage(string name, string[] extensions, string formatter, string adrFolder)
    {
        this.name = name;
        this.extensions = extensions == null ? Array.Empty<string>() : (string[])extensions.Clone();
        this.formatter = formatter;
        adr_folder = adrFolder;
    }
}
