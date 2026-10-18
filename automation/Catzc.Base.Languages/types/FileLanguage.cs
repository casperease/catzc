/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/types/FileLanguage.cs
    folder: types
    name: file-language
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-languages/types/FileLanguage.cs.md
    cites:
      - ADR-AUTO-MODULE#2
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#6
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class FileLanguage
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The file language's kebab-case name: its key in the `languages` map (e.g. powershell, pipeline-yaml).
    public string name { get; }

    public IReadOnlyList<string> extensions { get; }

    // The formatter engine Format-Code runs over the language's files (e.g. prettier). Null when it has none.
    public string formatter { get; }

    public string no_formatter { get; }

    // The VS Code language id of the language's files (e.g. azure-pipelines); its own name unless the entry states one.
    public string vscode_language { get; }

    // The language's ADR folder under docs/adr/ (e.g. pwsh). Null when it has none.
    public string adr_folder { get; }

    public IReadOnlyList<string> checks { get; }

    // The imprint steps Format-Code runs over this language's files only, after its formatter; empty when it has none of its own.
    public IReadOnlyList<string> imprint { get; }

    // The folders of a module this language owns and what each holds; empty when it owns none.
    public IReadOnlyList<LayoutRow> layout { get; }

    // How the language's test artifacts run, for a language that has them; null for every other language.
    public LanguageTestRunner tests { get; }

    public FileLanguage(string name, string[] extensions, string formatter, string noFormatter, string vscodeLanguage, string adrFolder,
        string[] checks, string[] imprint = null, LayoutRow[] layout = null, LanguageTestRunner tests = null)
    {
        this.tests = tests;
        this.layout = layout == null ? Array.Empty<LayoutRow>() : (LayoutRow[])layout.Clone();
        this.imprint = imprint == null ? Array.Empty<string>() : (string[])imprint.Clone();
        this.name = name;
        this.extensions = extensions == null ? Array.Empty<string>() : (string[])extensions.Clone();
        this.formatter = formatter;
        no_formatter = noFormatter;
        vscode_language = vscodeLanguage ?? name;
        adr_folder = adrFolder;
        this.checks = checks == null ? Array.Empty<string>() : (string[])checks.Clone();
    }
}
