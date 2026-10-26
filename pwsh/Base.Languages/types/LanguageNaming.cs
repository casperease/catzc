using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using Catzc.Base.Objects;

namespace Catzc.Base.Languages;

// A language's idiomatic names for its files and the folders that hold them, in the closed cases of NameCase; rests on [ADR-AUTO-IDIOM-CLOSEDCASES](/docs/drs/automation/idiomatic-names.md#rule-adr-auto-idiom-closedcases).
public sealed class LanguageNaming
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A role suffix sits outside the case, with one optional qualifier naming a tier or fixture: Get-Foo.Tests and Get-Foo.L2.Tests are verb-noun files.
    private static readonly Regex RoleSuffix = new Regex("(\\.[A-Z][A-Za-z0-9]*)?\\.Tests$");

    // The cases a folder on the path of one of the language's files may take; empty when the language judges no folder.
    public IReadOnlyList<string> folder { get; }

    // The cases a file name takes, less its extension; empty when the language judges no file name.
    public IReadOnlyList<string> file { get; }

    // The cases a function name defined in one of the language's files takes; empty when the language judges no function name.
    public IReadOnlyList<string> function { get; }

    // The cases a type name defined in one of the language's files takes; empty when the language judges no type name.
    public IReadOnlyList<string> type { get; }

    // Repository-relative files whose names are fixed outside the language's idiom (e.g. the importer every session dot-sources).
    public IReadOnlyList<string> exempt { get; }

    public LanguageNaming(string[] folder, string[] file, string[] exempt, string[] function = null, string[] type = null)
    {
        this.folder = folder == null ? Array.Empty<string>() : (string[])folder.Clone();
        this.file = file == null ? Array.Empty<string>() : (string[])file.Clone();
        this.exempt = exempt == null ? Array.Empty<string>() : (string[])exempt.Clone();
        this.function = function == null ? Array.Empty<string>() : (string[])function.Clone();
        this.type = type == null ? Array.Empty<string>() : (string[])type.Clone();
    }

    // A hidden folder keeps its leading dot outside the case: .internal is kebab.
    public bool IsFolderIdiomatic(string name) => folder.Count == 0 || Matches(folder, name.StartsWith(".", StringComparison.Ordinal) ? name.Substring(1) : name);

    public bool IsFileIdiomatic(string stem) => file.Count == 0 || Matches(file, WithoutRoleSuffix(stem));

    // A folder name rendered in the language's first folder case, its leading dot kept outside the case.
    public string IdiomaticFolder(string name)
    {
        if (folder.Count == 0 || IsFolderIdiomatic(name)) { return name; }
        bool hidden = name.StartsWith(".", StringComparison.Ordinal);
        return (hidden ? "." : "") + NameCase.Render(hidden ? name.Substring(1) : name, folder[0]);
    }

    // A file stem rendered in the language's first file case, its role suffix (.Tests) kept as written.
    public string IdiomaticFileStem(string stem)
    {
        if (file.Count == 0 || IsFileIdiomatic(stem)) { return stem; }
        string body = WithoutRoleSuffix(stem);
        return NameCase.Render(body, file[0]) + stem.Substring(body.Length);
    }

    // The cases the language names for one kind of name: folder, file, function or type.
    public IReadOnlyList<string> CasesOf(string kind)
    {
        switch (kind)
        {
            case "folder": return folder;
            case "file": return file;
            case "function": return function;
            case "type": return type;
            default: throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "naming: unknown kind '{0}' (one of: folder, file, function, type)", kind));
        }
    }

    // What breaks one defined name, or null: it must be in one of the kind's cases and round-trip through the normal form; rests on [ADR-AUTO-IDIOM-ROUNDTRIP](/docs/drs/automation/idiomatic-names.md#rule-adr-auto-idiom-roundtrip).
    public string JudgeName(string kind, string name, string normalForm)
    {
        IReadOnlyList<string> cases = CasesOf(kind);
        if (cases.Count == 0) { return null; }
        string caseName = cases.FirstOrDefault(c => NameCase.IsInCase(c, name));
        if (caseName == null) { return "is not " + string.Join(" or ", cases); }
        string back;
        try
        {
            back = NameCase.FromNormal(NameCase.ToNormal(caseName, name, normalForm), caseName, normalForm);
        }
        catch (ArgumentException e)
        {
            return "does not round-trip through the normal form (" + e.Message + ")";
        }
        return back == name ? null : "does not round-trip through the normal form (it renders back as " + back + ")";
    }

    // A module's test folder in this language: its folder's words joined in the first folder case, base_repository for Base.Repository when it is snake; rests on [ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM](/docs/drs/automation/idiomatic-names.md#rule-adr-auto-idiom-testfolderbyidiom).
    public string TestFolderOf(string module)
    {
        if (folder.Count == 0) { throw new InvalidOperationException("naming: the language names no folder case, so it names no test folder"); }
        string[][] segments = NameCase.Split("pascal-dotted", module);
        if (segments == null)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "naming: module '{0}' is not a pascal-dotted name, so it names no test folder", module));
        }
        return NameCase.Join(folder[0], segments);
    }

    private static string WithoutRoleSuffix(string stem)
    {
        Match suffix = RoleSuffix.Match(stem);
        return suffix.Success && suffix.Index > 0 ? stem.Substring(0, suffix.Index) : stem;
    }

    private static bool Matches(IReadOnlyList<string> cases, string name) => cases.Any(c => NameCase.IsInCase(c, name));
}
