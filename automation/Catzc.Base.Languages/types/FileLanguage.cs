// One file language of the registry (configs/languages.yml): the language a tracked file is written in, named by its extension.
// [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class FileLanguage
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The file language's kebab-case name: its key in the `languages` map (e.g. powershell, pipeline-yaml).
    public string name { get; }

    // The extensions that name the language: lowercase, each with its leading dot (e.g..ps1).
    // [comment:2](/docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md#comment2)
    public IReadOnlyList<string> extensions { get; }

    // The formatter engine Format-Code runs over the language's files (e.g. prettier). Null when it has none.
    public string formatter { get; }

    // Why the language has no formatter (e.g.
    // [comment:3](/docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md#comment3)
    public string no_formatter { get; }

    // The VS Code language id of the language's files (e.g. azure-pipelines); its own name unless the entry states one.
    public string vscode_language { get; }

    // The language's ADR folder under docs/adr/ (e.g. pwsh). Null when it has none.
    public string adr_folder { get; }

    // The quality gates that check a changed file of the language (e.g.
    // [comment:4](/docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md#comment4)
    public IReadOnlyList<string> checks { get; }

    public FileLanguage(string name, string[] extensions, string formatter, string noFormatter, string vscodeLanguage, string adrFolder,
        string[] checks)
    {
        this.name = name;
        this.extensions = extensions == null ? Array.Empty<string>() : (string[])extensions.Clone();
        this.formatter = formatter;
        no_formatter = noFormatter;
        vscode_language = vscodeLanguage ?? name;
        adr_folder = adrFolder;
        this.checks = checks == null ? Array.Empty<string>() : (string[])checks.Clone();
    }
}
