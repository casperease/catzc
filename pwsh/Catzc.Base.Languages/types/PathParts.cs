/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/PathParts.cs.md"
  header: "generated"
---
*/

using System;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class PathParts
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly Regex KebabPattern = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$", RegexOptions.Compiled);

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

    public static PathParts Of(string tail)
    {
        if (string.IsNullOrWhiteSpace(tail)) { throw new ArgumentException("path parts: the path is empty"); }
        string normalized = tail.Replace('\\', '/');
        int slash = normalized.LastIndexOf('/');
        string folder = slash < 0 ? "" : normalized.Substring(0, slash);
        string file = normalized.Substring(slash + 1);
        string filetype = FileTypeOf(file);
        string stem = filetype.Length == 0 ? file : file.Substring(0, file.Length - filetype.Length - 1);
        string name = Catzc.Base.Objects.NameCase.Render(stem, "kebab");
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
        string expected = string.Join("/", normalized.Split('/').Select(s => Catzc.Base.Objects.NameCase.Render(s, "kebab")));
        string actual = string.Join("/", built.ToString().Split('/').Select(s => Catzc.Base.Objects.NameCase.Render(s, "kebab")));
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
