/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/types/FileLanguage.cs
    folder: types
    name: file-language
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[FileLanguage.cs.md](docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md)"
    cites:
      - ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS
      - ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
      - ADR-DSGN-TRACK-FILELANGUAGE
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

// Rests on [ADR-AUTO-MODULE-EXISTSBYLAYOUT](/docs/adr/automation/module-model.md#rule-adr-auto-module-existsbylayout).
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

    // Whether a command may be implemented in the language ([ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](/docs/adr/automation/layers.md#rule-adr-auto-layers-commandispublicfunction)); false unless the entry says true.
    public bool executable { get; }

    // The language's idiomatic file and folder names; null for a language that states none.
    public LanguageNaming naming { get; }

    // Whether the importer has a handler for the language: an executable language whose layout rows place it in a module, or whose tests runner runs it ([ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS](/docs/adr/automation/importer.md#rule-adr-auto-importer-unhandledlanguagestops)).
    public bool handled => executable && (layout.Count > 0 || tests != null);

    public FileLanguage(string name, string[] extensions, string formatter, string noFormatter, string vscodeLanguage, string adrFolder,
        string[] checks, string[] imprint = null, LayoutRow[] layout = null, LanguageTestRunner tests = null, bool executable = false, LanguageNaming naming = null)
    {
        this.naming = naming;
        this.executable = executable;
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
