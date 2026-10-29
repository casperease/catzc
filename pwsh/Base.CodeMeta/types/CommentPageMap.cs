using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.CodeMeta;

// A `<prefix>/*` source matches each non-dot subfolder, a module, so a hidden folder needs an entry of its own to have pages.
public sealed class CommentPageMap
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    const string EachSubfolder = "/*";
    const string NormalCase = "kebab";
    const string TestsRole = ".Tests";
    const string ModuleArticle = "index";

    public string source { get; }
    public string docs { get; }

    // True when the source names each immediate subfolder of a prefix (`<prefix>/*`).
    public bool IsEachSubfolder => source.EndsWith(EachSubfolder, StringComparison.Ordinal);

    public CommentPageMap(string name, IDictionary raw)
    {
        if (raw == null)
        {
            throw new ArgumentException(name + ": a pages entry must be a map (source, docs)");
        }
        foreach (object key in raw.Keys)
        {
            string keyName = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (keyName != "source" && keyName != "docs")
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: source, docs)", name, keyName));
            }
        }
        source = Folder(name, "source", raw["source"]);
        docs = Folder(name, "docs", raw["docs"]);
        string sourceWithoutStar = IsEachSubfolder ? source.Substring(0, source.Length - EachSubfolder.Length) : source;
        if (sourceWithoutStar.IndexOf('*') >= 0 || sourceWithoutStar.IndexOf('?') >= 0 || sourceWithoutStar.Length == 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: source '{1}' must be a folder, or a folder followed by '/*' (only a trailing '/*' is supported)", name, source));
        }
        if (!docs.StartsWith("docs/", StringComparison.Ordinal))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: docs '{1}' must be a folder under docs/", name, docs));
        }
        if (docs.IndexOfAny(new[] { '*', '?', '{', '}' }) >= 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: docs '{1}' must be a plain folder; the module, aspect and file parts below it are derived", name, docs));
        }
    }

    // The page of a file under this map's source, or null: <docs>/[<module>/][<aspect path>/]<file>.md, every part in the normal form.
    public string PageFor(string repoRelativePath, IReadOnlyCollection<string> keepExtensions)
    {
        string below = Below(repoRelativePath, out string module);
        if (below == null)
        {
            return null;
        }
        string[] parts = below.Split('/');
        var normal = parts.Take(parts.Length - 1).Select(Normal).ToList();
        normal.Add(FileStem(parts[parts.Length - 1], keepExtensions));
        if (module != null)
        {
            normal.Insert(0, Normal(module));
        }
        return normal.Any(string.IsNullOrEmpty) ? null : docs + "/" + string.Join("/", normal) + ".md";
    }

    // The article page of a module folder under a `<prefix>/*` source, <docs>/<module>/index.md, or null for any other folder.
    public string ModulePageFor(string repoRelativeFolder)
    {
        if (!IsEachSubfolder || string.IsNullOrEmpty(repoRelativeFolder))
        {
            return null;
        }
        string folder = repoRelativeFolder.Replace('\\', '/').TrimEnd('/');
        string prefix = source.Substring(0, source.Length - EachSubfolder.Length) + "/";
        if (!folder.StartsWith(prefix, StringComparison.Ordinal))
        {
            return null;
        }
        string leaf = folder.Substring(prefix.Length);
        if (leaf.Length == 0 || leaf.Contains('/') || leaf[0] == '.')
        {
            return null;
        }
        string module = Normal(leaf);
        return string.IsNullOrEmpty(module) ? null : docs + "/" + module + "/" + ModuleArticle + ".md";
    }

    // The module folder a file sits in under a `<prefix>/*` source (`pwsh/Base.Repository`), or null.
    public string ModuleFolderOf(string repoRelativePath) =>
        IsEachSubfolder && Below(repoRelativePath, out string module) != null
            ? source.Substring(0, source.Length - EachSubfolder.Length) + "/" + module
            : null;

    // The path of a file below the source (and below its module folder, which `module` returns), or null when the map does not cover it.
    string Below(string repoRelativePath, out string module)
    {
        module = null;
        if (string.IsNullOrEmpty(repoRelativePath))
        {
            return null;
        }
        string path = repoRelativePath.Replace('\\', '/');
        if (!IsEachSubfolder)
        {
            if (!path.StartsWith(source + "/", StringComparison.Ordinal) || path.Length == source.Length + 1)
            {
                return null;
            }
            return path.Substring(source.Length + 1);
        }
        string prefix = source.Substring(0, source.Length - EachSubfolder.Length) + "/";
        if (!path.StartsWith(prefix, StringComparison.Ordinal))
        {
            return null;
        }
        string underPrefix = path.Substring(prefix.Length);
        int slash = underPrefix.IndexOf('/');
        if (slash <= 0 || slash == underPrefix.Length - 1 || underPrefix[0] == '.')
        {
            return null;
        }
        module = underPrefix.Substring(0, slash);
        return underPrefix.Substring(slash + 1);
    }

    // A folder or module name in the normal form: Base.QualityGates is base-quality-gates; a namespace never appears in a folder.
    static string Normal(string segment) => Catzc.Base.Objects.NameCase.Render(segment, NormalCase);

    static string FileStem(string fileName, IReadOnlyCollection<string> keep)
    {
        string stem = fileName;
        int dot = stem.LastIndexOf('.');
        if (dot > 0)
        {
            if (keep.Contains(stem.Substring(dot), StringComparer.OrdinalIgnoreCase))
            {
                return Normal(stem);
            }
            stem = stem.Substring(0, dot);
        }
        if (stem.EndsWith(TestsRole, StringComparison.Ordinal) && stem.Length > TestsRole.Length)
        {
            stem = stem.Substring(0, stem.Length - TestsRole.Length);
        }
        return Normal(stem);
    }

    static string Folder(string name, string key, object value)
    {
        string folder = Convert.ToString(value, CultureInfo.InvariantCulture);
        if (string.IsNullOrWhiteSpace(folder))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: {1} is required", name, key));
        }
        if (folder.IndexOf('\\') >= 0 || folder.StartsWith("/", StringComparison.Ordinal) || folder.EndsWith("/", StringComparison.Ordinal))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: {1} '{2}' must be a repository-relative, '/'-separated folder with no leading or trailing '/'", name, key, folder));
        }
        return folder;
    }
}
