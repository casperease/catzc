using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// A language's idiomatic names for its files and the folders that hold them; rests on [ADR-AUTO-IDIOM-CLOSEDCASES](/docs/adr/automation/idiomatic-names.md#rule-adr-auto-idiom-closedcases).
public sealed class LanguageNaming
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A new case is new mechanism: its pattern here, and its split and its join below, land together.
    private static readonly Dictionary<string, Regex> Patterns = new Dictionary<string, Regex>(StringComparer.Ordinal)
    {
        { "pascal", new Regex("^[A-Z][A-Za-z0-9]*$") },
        { "pascal-dotted", new Regex("^[A-Z][A-Za-z0-9]*(\\.[A-Z][A-Za-z0-9]*)*$") },
        { "verb-noun", new Regex("^[A-Z][A-Za-z0-9]*-[A-Z][A-Za-z0-9]*$") },
        { "kebab", new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$") },
        // Python's leading and trailing underscores sit outside the case: drawio_png, _private, __init__.
        { "snake", new Regex("^_*[a-z][a-z0-9]*(_[a-z0-9]+)*_*$") },
        // One lowercase word, Go's package directory: catzcbaserepository.
        { "flat", new Regex("^[a-z][a-z0-9]*$") },
    };

    // A role suffix sits outside the case, with one optional qualifier naming a tier or fixture: Get-Foo.Tests and Get-Foo.L2.Tests are verb-noun files.
    private static readonly Regex RoleSuffix = new Regex("(\\.[A-Z][A-Za-z0-9]*)?\\.Tests$");

    // A word starts at a lower-to-upper step, and at the last capital of a run before a lowercase letter: HTTPServer is http, server.
    private static readonly Regex Boundary = new Regex("(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])");
    private static readonly Regex NotWord = new Regex("[^a-z0-9]+");
    private static readonly Regex Word = new Regex("^[a-z0-9]+$");

    // The engine's approved verbs, each as its words (ConvertTo is convert, to); the engine owns the set.
    private static readonly Lazy<HashSet<string>> ApprovedVerbs = new Lazy<HashSet<string>>(ReadApprovedVerbs);

    public static IReadOnlyList<string> Cases { get; } = Patterns.Keys.ToArray();

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

    public static bool IsCase(string name) => name != null && Patterns.ContainsKey(name);

    public static bool IsInCase(string caseName, string name) => name != null && CaseOf(caseName).IsMatch(name);

    // A hidden folder keeps its leading dot outside the case: .internal is kebab.
    public bool IsFolderIdiomatic(string name) => folder.Count == 0 || Matches(folder, name.StartsWith(".", StringComparison.Ordinal) ? name.Substring(1) : name);

    public bool IsFileIdiomatic(string stem) => file.Count == 0 || Matches(file, WithoutRoleSuffix(stem));

    // A name in a case as its namespace segments, each a list of lowercase words; null when the name is not in the case.
    public static string[][] Split(string caseName, string name)
    {
        if (!IsInCase(caseName, name)) { return null; }
        switch (caseName)
        {
            case "pascal-dotted": return name.Split('.').Select(PascalWords).ToArray();
            case "verb-noun": return new[] { name.Split('-').SelectMany(PascalWords).ToArray() };
            case "kebab": return new[] { name.Split('-') };
            case "snake": return new[] { name.Trim('_').Split('_') };
            case "flat": return new[] { new[] { name } };
            default: return new[] { PascalWords(name) };
        }
    }

    // Namespace segments of lowercase words joined in a case; a case without namespaces joins every segment's words as one run.
    public static string Join(string caseName, string[][] segments)
    {
        CaseOf(caseName);
        if (segments == null) { throw new ArgumentNullException(nameof(segments)); }
        string[] bad = segments.SelectMany(s => s ?? Array.Empty<string>()).Where(w => w == null || !Word.IsMatch(w)).ToArray();
        if (bad.Length > 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "naming: '{0}' is not a lowercase word", bad[0]));
        }
        string[] words = segments.SelectMany(s => s ?? Array.Empty<string>()).ToArray();
        switch (caseName)
        {
            case "pascal-dotted": return string.Join(".", segments.Where(s => s != null && s.Length > 0).Select(s => string.Concat(s.Select(Capitalize))));
            case "verb-noun": return JoinVerbNoun(words);
            case "kebab": return string.Join("-", words);
            case "snake": return string.Join("_", words);
            case "flat": return string.Concat(words);
            default: return string.Concat(words.Select(Capitalize));
        }
    }

    // A catzc module's test folder in this language: the module's words joined in the first folder case, catzc_base_repository when it is snake; rests on [ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM](/docs/adr/automation/idiomatic-names.md#rule-adr-auto-idiom-testfolderbyidiom).
    public string TestFolderOf(string module)
    {
        if (folder.Count == 0) { throw new InvalidOperationException("naming: the language names no folder case, so it names no test folder"); }
        string[][] segments = Split("pascal-dotted", module);
        if (segments == null)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "naming: module '{0}' is not a pascal-dotted name, so it names no test folder", module));
        }
        return Join(folder[0], segments);
    }

    // Any text as one segment of words: a case boundary, '.', '_', '-' and any other non-letter start a new word.
    public static string[] WordsOf(string text) =>
        NotWord.Replace(Boundary.Replace(text ?? "", "-").ToLowerInvariant(), "-").Split('-', StringSplitOptions.RemoveEmptyEntries);

    // Any text rendered in a case by its words: Render('Get-FooBar', 'kebab') is get-foo-bar; empty for text with no word.
    public static string Render(string text, string caseName) => Join(caseName, new[] { WordsOf(text) });

    private static Regex CaseOf(string caseName)
    {
        Regex pattern;
        if (caseName == null || !Patterns.TryGetValue(caseName, out pattern))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "naming: unknown case '{0}' (one of: {1})", caseName, string.Join(", ", Cases)));
        }
        return pattern;
    }

    private static string[] PascalWords(string segment) => Boundary.Split(segment).Select(w => w.ToLowerInvariant()).ToArray();

    private static string Capitalize(string word) => word.Length == 0 ? word : char.ToUpperInvariant(word[0]) + word.Substring(1);

    // The verb is the longest leading run of words that forms an approved verb, and at least one word is left for the noun.
    private static string JoinVerbNoun(string[] words)
    {
        for (int length = words.Length - 1; length > 0; length--)
        {
            if (ApprovedVerbs.Value.Contains(string.Join(" ", words.Take(length))))
            {
                return string.Concat(words.Take(length).Select(Capitalize)) + "-" + string.Concat(words.Skip(length).Select(Capitalize));
            }
        }
        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "naming: '{0}' starts with no approved verb and a noun after it", string.Join(" ", words)));
    }

    private static HashSet<string> ReadApprovedVerbs()
    {
        HashSet<string> verbs = new HashSet<string>(StringComparer.Ordinal);
        IEnumerable<Type> holders = typeof(System.Management.Automation.VerbsCommon).Assembly.GetExportedTypes()
            .Where(t => t.Namespace == "System.Management.Automation" && t.Name.StartsWith("Verbs", StringComparison.Ordinal) && t.IsAbstract && t.IsSealed);
        foreach (Type holder in holders)
        {
            foreach (FieldInfo field in holder.GetFields(BindingFlags.Public | BindingFlags.Static).Where(f => f.IsLiteral && f.FieldType == typeof(string)))
            {
                verbs.Add(string.Join(" ", PascalWords((string)field.GetRawConstantValue())));
            }
        }
        return verbs;
    }

    private static string WithoutRoleSuffix(string stem)
    {
        Match suffix = RoleSuffix.Match(stem);
        return suffix.Success && suffix.Index > 0 ? stem.Substring(0, suffix.Index) : stem;
    }

    private static bool Matches(IReadOnlyList<string> cases, string name) => cases.Any(c => Patterns[c].IsMatch(name));
}
