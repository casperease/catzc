using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.CodeMeta;

public sealed class CommentPagesConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly string[] AllowedKeys = { "pages", "articles", "exclude", "keep_extensions" };

    // The extensions a page name keeps by default: a .bicepparam file would otherwise share its page with its sibling .yml.
    public static readonly IReadOnlyList<string> DefaultKeepExtensions = new[] { ".bicepparam" };

    public static readonly IReadOnlyList<(string source, string docs)> DefaultPages = new[]
    {
        ("pwsh/*", "docs/references/pwsh"),
        (".ado/pipelines", "docs/references/ado/pipelines"),
        ("infrastructure", "docs/references/infrastructure"),
        (".claude/hooks", "docs/references/pwsh/claude-hooks"),
    };

    public IReadOnlyList<CommentPageMap> pages { get; }

    // The authored pages under a pages docs folder that no source file has; every other page there maps back to one source.
    public IReadOnlyList<string> articles { get; }

    // The folders under a pages source whose files have no page, such as vendored scripts we ship but do not write.
    public IReadOnlyList<string> exclude { get; }

    // The extensions a page name keeps; every other extension is dropped, so a file and its sibling of another kind share no page.
    public IReadOnlyList<string> keep_extensions { get; }

    public CommentPagesConfig(IDictionary raw)
    {
        var keepList = DefaultKeepExtensions.ToList();
        const string name = "comment-pages config";
        var pageMaps = DefaultPages.Select(d => new CommentPageMap(name + ": pages", new Hashtable { ["source"] = d.source, ["docs"] = d.docs })).ToList();
        var articleList = new List<string>();
        var excludeList = new List<string>();

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string keyName = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, keyName) < 0)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "{0}: unknown key '{1}' (allowed: {2})", name, keyName, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("pages") && raw["pages"] != null)
            {
                if (!(raw["pages"] is IList pagesRaw) || pagesRaw.Count == 0)
                {
                    throw new ArgumentException(name + ": pages must be a non-empty list of { source, docs } entries");
                }
                pageMaps = new List<CommentPageMap>();
                int index = 0;
                foreach (object entry in pagesRaw)
                {
                    pageMaps.Add(new CommentPageMap(string.Format(CultureInfo.InvariantCulture, "{0}: pages[{1}]", name, index), entry as IDictionary));
                    index++;
                }
            }

            if (raw.Contains("articles") && raw["articles"] != null)
            {
                if (!(raw["articles"] is IList articlesRaw) || raw["articles"] is string)
                {
                    throw new ArgumentException(name + ": articles must be a list of page paths");
                }
                foreach (object entry in articlesRaw)
                {
                    string article = Convert.ToString(entry, CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(article) || !article.StartsWith("docs/", StringComparison.Ordinal) ||
                        !article.EndsWith(".md", StringComparison.Ordinal) || article.Contains('\\'))
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "{0}: article '{1}' must be a '/'-separated .md path under docs/", name, article));
                    }
                    articleList.Add(article);
                }
            }

            if (raw.Contains("exclude") && raw["exclude"] != null)
            {
                if (!(raw["exclude"] is IList excludeRaw) || raw["exclude"] is string)
                {
                    throw new ArgumentException(name + ": exclude must be a list of folders");
                }
                foreach (object entry in excludeRaw)
                {
                    string folder = Convert.ToString(entry, CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(folder) || folder.Contains('\\') || folder.Contains('*') ||
                        folder.StartsWith("/", StringComparison.Ordinal) || folder.EndsWith("/", StringComparison.Ordinal))
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "{0}: exclude '{1}' must be a repository-relative, '/'-separated folder with no pattern", name, folder));
                    }
                    excludeList.Add(folder);
                }
            }

            if (raw.Contains("keep_extensions") && raw["keep_extensions"] != null)
            {
                if (!(raw["keep_extensions"] is IList keepRaw) || raw["keep_extensions"] is string)
                {
                    throw new ArgumentException(name + ": keep_extensions must be a list of extensions");
                }
                keepList = new List<string>();
                foreach (object entry in keepRaw)
                {
                    string extension = Convert.ToString(entry, CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(extension) || !extension.StartsWith(".", StringComparison.Ordinal) || extension.Length == 1 || extension.Contains('/'))
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "{0}: keep_extensions entry '{1}' must be an extension with its leading dot", name, extension));
                    }
                    keepList.Add(extension);
                }
            }
        }

        pages = pageMaps;
        articles = articleList;
        exclude = excludeList;
        keep_extensions = keepList;
    }

    // True when a file sits in an excluded folder, so it has no page.
    public bool IsExcluded(string repoRelativePath) =>
        !string.IsNullOrEmpty(repoRelativePath) &&
        exclude.Any(folder => repoRelativePath.Replace('\\', '/').StartsWith(folder + "/", StringComparison.Ordinal));

    // The page of a repository-relative file: the first pages map that covers it, or null when none does or the file is excluded.
    public string PageFor(string repoRelativePath) =>
        IsExcluded(repoRelativePath) ? null : pages.Select(map => map.PageFor(repoRelativePath, keep_extensions)).FirstOrDefault(page => page != null);

    // The article page of a module folder: the first pages map whose modules include it, or null.
    public string ModulePageFor(string repoRelativeFolder) =>
        pages.Select(map => map.ModulePageFor(repoRelativeFolder)).FirstOrDefault(page => page != null);

    // True when a page sits under the docs folder of a pages map, where it must map back to a source or be an article.
    public bool IsInScope(string page) =>
        !string.IsNullOrEmpty(page) && pages.Any(map => page.StartsWith(map.docs + "/", StringComparison.Ordinal));

    // Page to source: the files map forward once and invert, since the normal form reads back to no name; two on a page collide.
    public IReadOnlyDictionary<string, IReadOnlyList<string>> PageIndex(IEnumerable<string> repoRelativePaths)
    {
        var index = new SortedDictionary<string, List<string>>(StringComparer.Ordinal);
        var modules = new HashSet<string>(StringComparer.Ordinal);
        foreach (string raw in repoRelativePaths ?? Enumerable.Empty<string>())
        {
            string path = raw?.Replace('\\', '/');
            if (IsExcluded(path))
            {
                continue;
            }
            CommentPageMap map = pages.FirstOrDefault(m => m.PageFor(path, keep_extensions) != null);
            if (map == null)
            {
                continue;
            }
            Add(index, map.PageFor(path, keep_extensions), path);
            string module = map.ModuleFolderOf(path);
            if (module != null && modules.Add(module))
            {
                Add(index, map.ModulePageFor(module), module);
            }
        }
        return index.ToDictionary(e => e.Key, e => (IReadOnlyList<string>)e.Value, StringComparer.Ordinal);
    }

    static void Add(SortedDictionary<string, List<string>> index, string page, string source)
    {
        if (page == null)
        {
            return;
        }
        if (!index.TryGetValue(page, out List<string> sources))
        {
            index[page] = sources = new List<string>();
        }
        sources.Add(source);
    }
}
