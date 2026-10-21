/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.CodeMeta/types/CommentPageMap.cs
    folder: types
    name: comment-page-map
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[CommentPageMap.cs.md](docs/references/pwsh/catzc-base-codemeta/types/CommentPageMap.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-PRIN-ONELIVE-ONEVERSION
      - ADR-REPO-README-AUTHOREDSOURCES
---
*/

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.CodeMeta;

public sealed class CommentPageMap
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    const string KebabPlaceholder = "{kebab}";
    const string EachSubfolder = "/*";

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
        if (docs.IndexOf('*') >= 0 || docs.IndexOf('?') >= 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: docs '{1}' must be a plain folder, not a pattern", name, docs));
        }
        if (docs.Contains(KebabPlaceholder) && !IsEachSubfolder)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: docs '{1}' uses {2}, which needs a source ending in '/*'", name, docs, KebabPlaceholder));
        }
    }

    // The page path of a repository-relative file under this map's source, or null when the file is not under it.
    public string PageFor(string repoRelativePath)
    {
        if (string.IsNullOrEmpty(repoRelativePath)) { return null; }
        string path = repoRelativePath.Replace('\\', '/');

        if (!IsEachSubfolder)
        {
            if (!path.StartsWith(source + "/", StringComparison.Ordinal) || path.Length == source.Length + 1) { return null; }
            return docs + "/" + path.Substring(source.Length + 1) + ".md";
        }

        string prefix = source.Substring(0, source.Length - EachSubfolder.Length) + "/";
        if (!path.StartsWith(prefix, StringComparison.Ordinal)) { return null; }
        string underPrefix = path.Substring(prefix.Length);
        int slash = underPrefix.IndexOf('/');
        if (slash <= 0 || slash == underPrefix.Length - 1) { return null; }
        string leaf = underPrefix.Substring(0, slash);
        if (leaf[0] == '.') { return null; }
        string kebab = leaf.ToLowerInvariant().Replace('.', '-');
        return docs.Replace(KebabPlaceholder, kebab) + "/" + underPrefix.Substring(slash + 1) + ".md";
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
