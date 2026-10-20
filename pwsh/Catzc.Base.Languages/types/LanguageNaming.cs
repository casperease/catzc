using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// A language's idiomatic names for its files and the folders that hold them; rests on [ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md).
public sealed class LanguageNaming
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A new case is new mechanism: its pattern and its name here land together.
    private static readonly Dictionary<string, Regex> Patterns = new Dictionary<string, Regex>(StringComparer.Ordinal)
    {
        // PascalCase words joined by dots or hyphens: Catzc.Base.Repository, Get-Foo, Get-Foo.Tests.
        { "pascal", new Regex("^[A-Z][A-Za-z0-9]*([.-][A-Z][A-Za-z0-9]*)*$") },
        { "kebab", new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$") },
        // Lowercase words joined by underscores, with Python's leading and trailing underscores: drawio_png, _private, __init__.
        { "snake", new Regex("^_*[a-z][a-z0-9]*(_[a-z0-9]+)*_*$") },
        // One lowercase word, Go's package directory: catzcbaserepository.
        { "flat", new Regex("^[a-z][a-z0-9]*$") },
    };

    public static IReadOnlyList<string> Cases { get; } = Patterns.Keys.ToArray();

    // The cases a folder on the path of one of the language's files may take; empty when the language judges no folder.
    public IReadOnlyList<string> folder { get; }

    // The cases a file name takes, less its extension; empty when the language judges no file name.
    public IReadOnlyList<string> file { get; }

    // Repository-relative files whose names are fixed outside the language's idiom (e.g. the importer every session dot-sources).
    public IReadOnlyList<string> exempt { get; }

    public LanguageNaming(string[] folder, string[] file, string[] exempt)
    {
        this.folder = folder == null ? Array.Empty<string>() : (string[])folder.Clone();
        this.file = file == null ? Array.Empty<string>() : (string[])file.Clone();
        this.exempt = exempt == null ? Array.Empty<string>() : (string[])exempt.Clone();
    }

    public static bool IsCase(string name) => name != null && Patterns.ContainsKey(name);

    // A hidden folder keeps its leading dot outside the case: .internal is kebab.
    public bool IsFolderIdiomatic(string name) => folder.Count == 0 || Matches(folder, name.StartsWith(".", StringComparison.Ordinal) ? name.Substring(1) : name);

    public bool IsFileIdiomatic(string stem) => file.Count == 0 || Matches(file, stem);

    private static bool Matches(IReadOnlyList<string> cases, string name) => cases.Any(c => Patterns[c].IsMatch(name));
}
