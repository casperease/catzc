/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/FileSelector.cs.md"
  header: "generated"
---
*/

// A file is picked by its class and its language, never by a glob: the globs live once, in the registry's ordered classes.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.QualityGates;

[Catzc.Base.Objects.ConsoleDisplay("classes", "languages")]
public sealed class FileSelector
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly string[] Allowed = { "classes", "languages" };

    // Class patterns, each a class name with at most one '*'; empty selects every class.
    public IReadOnlyList<string> classes { get; }

    // Language names from the file-language registry; empty selects every language.
    public IReadOnlyList<string> languages { get; }

    // The selector that picks every file.
    public static FileSelector Any { get; } = new FileSelector(Array.Empty<string>(), Array.Empty<string>());

    public FileSelector(IReadOnlyList<string> classes, IReadOnlyList<string> languages)
    {
        this.classes = classes ?? Array.Empty<string>();
        this.languages = languages ?? Array.Empty<string>();
    }

    // One `select` entry: { classes, languages }, at least one of them; a file must match both that are given.
    public static FileSelector Parse(string where, object raw)
    {
        if (!(raw is IDictionary map))
        {
            throw new ArgumentException(where + ": a select entry is a map of classes and/or languages");
        }
        foreach (object key in map.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (!Allowed.Contains(name))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "{0}: unknown select key '{1}' (allowed: {2})", where, name, string.Join(", ", Allowed)));
            }
        }
        List<string> classList = Strings(where, "classes", map);
        List<string> languageList = Strings(where, "languages", map);
        if (classList.Count == 0 && languageList.Count == 0)
        {
            throw new ArgumentException(where + ": a select entry names classes, languages, or both");
        }
        foreach (string pattern in classList)
        {
            if (pattern.Count(c => c == '*') > 1)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: class pattern '{1}' holds more than one '*'", where, pattern));
            }
        }
        return new FileSelector(classList, languageList);
    }

    public bool Selects(string fileClass, string language) =>
        (classes.Count == 0 || classes.Any(pattern => ClassMatches(pattern, fileClass)))
        && (languages.Count == 0 || (language != null && languages.Contains(language, StringComparer.Ordinal)));

    public static bool ClassMatches(string pattern, string fileClass)
    {
        if (pattern == null || fileClass == null) { return false; }
        int slash = fileClass.IndexOf('/');
        if (slash >= 0 && pattern.IndexOf('/') < 0) { fileClass = fileClass.Substring(0, slash); }
        int star = pattern.IndexOf('*');
        if (star < 0) { return string.Equals(pattern, fileClass, StringComparison.Ordinal); }
        string prefix = pattern.Substring(0, star);
        string suffix = pattern.Substring(star + 1);
        return fileClass.Length >= prefix.Length + suffix.Length
            && fileClass.StartsWith(prefix, StringComparison.Ordinal)
            && fileClass.EndsWith(suffix, StringComparison.Ordinal);
    }

    static List<string> Strings(string where, string name, IDictionary map)
    {
        var items = new List<string>();
        if (!map.Contains(name) || map[name] == null) { return items; }
        object value = map[name];
        if (value is string single) { items.Add(single); }
        else if (value is IEnumerable list) { foreach (object item in list) { items.Add(Convert.ToString(item, CultureInfo.InvariantCulture)); } }
        else { throw new ArgumentException(where + ": " + name + " must be a list of strings"); }
        if (items.Any(string.IsNullOrWhiteSpace)) { throw new ArgumentException(where + ": " + name + " holds an empty entry"); }
        return items;
    }
}
