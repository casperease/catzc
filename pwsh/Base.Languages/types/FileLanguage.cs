/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/FileLanguage.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

// Rests on [ADR-AUTO-MODULE-EXISTSBYLAYOUT](/docs/drs/automation/module-model.md#rule-adr-auto-module-existsbylayout).
public sealed class FileLanguage
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The file language's kebab-case name: its key in the `languages` map (e.g. powershell, pipeline-yaml).
    public string name { get; }

    // Lowercase with the leading dot; each belongs to exactly one language.
    public IReadOnlyList<string> extensions { get; }

    // The formatter engine Format-Code runs over the language's files (e.g. prettier). Null when it has none.
    public string formatter { get; }

    // Why there is no formatter; an entry carries exactly one of formatter and no_formatter.
    public string no_formatter { get; }

    // The VS Code language id of the language's files (e.g. azure-pipelines); its own name unless the entry states one.
    public string vscode_language { get; }

    // The language's ADR folder under docs/drs/ (e.g. pwsh). Null when it has none.
    public string adr_folder { get; }

    // The gates Test-Change runs over a changed file of the language, in order.
    public IReadOnlyList<string> checks { get; }

    // The config address of the folder a check governs; a check with no entry governs every file of the language.
    public IReadOnlyDictionary<string, string> check_scopes { get; }

    // The imprint steps Format-Code runs over this language's files only, after its formatter; empty when it has none of its own.
    public IReadOnlyList<string> imprint { get; }

    // The folders of a module this language owns and what each holds; empty when it owns none.
    public IReadOnlyList<LayoutRow> layout { get; }

    // How the language's test artifacts run, for a language that has them; null for every other language.
    public LanguageTestRunner tests { get; }

    // Whether a command may be implemented in the language ([ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](/docs/drs/automation/layers.md#rule-adr-auto-layers-commandispublicfunction)); false unless the entry says true.
    public bool executable { get; }

    // The language's idiomatic file and folder names; null for a language that states none.
    public LanguageNaming naming { get; }

    // The short word a diagram prints on a glyph whose label is a snippet of this language (e.g. pwsh); null when it prints none.
    public string tag { get; }

    // The ordered regular expressions that name a label as this language's snippet; first match wins across the languages in order.
    public IReadOnlyList<string> shapes { get; }

    // Whether the importer has a handler for the language: an executable language whose layout rows place it in a module, or whose tests runner runs it ([ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS](/docs/drs/automation/importer.md#rule-adr-auto-importer-unhandledlanguagestops)).
    public bool handled => executable && (layout.Count > 0 || tests != null);

    public FileLanguage(string name, string[] extensions, string formatter, string noFormatter, string vscodeLanguage, string adrFolder,
        string[] checks, string[] imprint = null, LayoutRow[] layout = null, LanguageTestRunner tests = null, bool executable = false, LanguageNaming naming = null,
        IDictionary<string, string> checkScopes = null, string tag = null, string[] shapes = null)
    {
        this.tag = tag;
        this.shapes = shapes == null ? Array.Empty<string>() : (string[])shapes.Clone();
        check_scopes = checkScopes == null
            ? new Dictionary<string, string>()
            : new Dictionary<string, string>(checkScopes);
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
