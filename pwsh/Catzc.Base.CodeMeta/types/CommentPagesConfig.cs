/*
---
catzc:
  immutable:
    with_body_sha: f0c925612378
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/types/CommentPagesConfig.Tests.ps1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.CodeMeta;

public sealed class CommentPagesConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly string[] AllowedKeys = { "pages" };

    public static readonly IReadOnlyList<(string source, string docs)> DefaultPages = new[]
    {
        ("pwsh/*", "docs/references/pwsh/{kebab}"),
        (".ado/pipelines", "docs/references/ado/pipelines"),
        ("infrastructure", "docs/references/infrastructure"),
        (".claude/hooks", "docs/references/pwsh/claude-hooks"),
    };

    public IReadOnlyList<CommentPageMap> pages { get; }

    public CommentPagesConfig(IDictionary raw)
    {
        const string name = "comment-pages config";
        var pageMaps = DefaultPages.Select(d => new CommentPageMap(name + ": pages", new Hashtable { ["source"] = d.source, ["docs"] = d.docs })).ToList();

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
        }

        pages = pageMaps;
    }

    // The comment page of a repository-relative file: the first pages map that covers it, or null when none does.
    public string PageFor(string repoRelativePath) =>
        pages.Select(map => map.PageFor(repoRelativePath)).FirstOrDefault(page => page != null);
}
