/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/types/PathParts.cs
    folder: types
    name: path-parts
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: automation/Catzc.Base.Languages/tests/types/PathParts.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#11
---
*/

using System;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// [ADR-REPO-FILEMETA#11](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta11): a path under its module is an optional folder, a
// kebab-case name and a file type, and only that.
public sealed class PathParts
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly Regex KebabPattern = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$", RegexOptions.Compiled);
    static readonly Regex Boundary = new Regex("(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])", RegexOptions.Compiled);
    static readonly Regex NotWord = new Regex("[^a-z0-9]+", RegexOptions.Compiled);

    // The folders between the module and the file, '/'-separated; empty for a file directly in the module.
    public string folder { get; }

    // The file's name without its file type, in kebab case: Get-FooBar and GetFooBar are both get-foo-bar.
    public string name { get; }

    // The extension of the file's name, lower case, without the dot; empty for a file with none.
    public string filetype { get; }

    PathParts(string folder, string name, string filetype)
    {
        this.folder = folder;
        this.name = name;
        this.filetype = filetype;
    }

    // The extension of the last segment of a '/' or '\' separated path, lower case; a dotfile and a trailing dot have none.
    public static string FileTypeOf(string path)
    {
        string file = FileNameOf(path);
        int dot = file.LastIndexOf('.');
        return dot > 0 && dot < file.Length - 1 ? file.Substring(dot + 1).ToLowerInvariant() : "";
    }

    // The words of a name joined by '-', lower case: a case boundary, '.', '_' and any other non-letter start a new word.
    public static string Kebab(string text) =>
        NotWord.Replace(Boundary.Replace(text ?? "", "-").ToLowerInvariant(), "-").Trim('-');

    // Splits a '/' or '\' separated path under its module (the whole path for a file in no module) and asserts that the three parts
    // build the path back: the folders, the name and the file type, compared as kebab case.
    public static PathParts Of(string tail)
    {
        if (string.IsNullOrWhiteSpace(tail)) { throw new ArgumentException("path parts: the path is empty"); }
        string normalized = tail.Replace('\\', '/');
        int slash = normalized.LastIndexOf('/');
        string folder = slash < 0 ? "" : normalized.Substring(0, slash);
        string file = normalized.Substring(slash + 1);
        string filetype = FileTypeOf(file);
        string stem = filetype.Length == 0 ? file : file.Substring(0, file.Length - filetype.Length - 1);
        string name = Kebab(stem);
        if (!KebabPattern.IsMatch(name))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "path parts: the file name '{0}' of '{1}' holds no letter or digit to name it by", file, tail));
        }
        if (folder.Split('/').Any(segment => folder.Length > 0 && segment.Length == 0))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "path parts: '{0}' holds an empty folder segment", tail));
        }
        var built = new StringBuilder();
        if (folder.Length > 0) { built.Append(folder).Append('/'); }
        built.Append(name);
        if (filetype.Length > 0) { built.Append('.').Append(filetype); }
        string expected = string.Join("/", normalized.Split('/').Select(Kebab));
        string actual = string.Join("/", built.ToString().Split('/').Select(Kebab));
        if (!string.Equals(expected, actual, StringComparison.Ordinal))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "path parts: '{0}' is not its folder '{1}', its name '{2}' and its file type '{3}'", tail, folder, name, filetype));
        }
        return new PathParts(folder, name, filetype);
    }

    static string FileNameOf(string path)
    {
        int slash = Math.Max(path.LastIndexOf('/'), path.LastIndexOf('\\'));
        return path.Substring(slash + 1);
    }
}
