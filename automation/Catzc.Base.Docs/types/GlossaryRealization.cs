// How a glossary concept exists in the repository (a configs/glossary.yml `realized_by:` mapping): a kind from a
// closed set and, for every kind except prose-only, the pattern that locates it — a repo-relative glob, a tag, or
// an identifier, never a URL (every glossary source and reference stays in the repository, ADR-REPO-VOCAB:3). A
// prose-only concept is a pure vocabulary term with nothing in code to enforce (ADR-REPO-VOCAB:6), so it carries no
// pattern. Mirrors the YAML mapping (snake_case keys, ADR-AUTO-TYPES:8).

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class GlossaryRealization : Catzc.Base.Objects.DictionaryRecord
{
    // The closed set of realization kinds.
    public static readonly IReadOnlyList<string> Kinds = new[]
    {
        "folder", "file-pattern", "tag", "config-key", "type", "function", "artifact", "prose-only"
    };

    // One of Kinds. Required.
    public string kind { get; }

    // Locates the realization. Required for every kind except prose-only, where it must be absent.
    public string pattern { get; }

    public GlossaryRealization(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("realized_by must be a mapping with 'kind' (and 'pattern')"); }
        kind    = Req(d, "kind");
        pattern = OptStr(d, "pattern");

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "kind" && key != "pattern")
            {
                throw new ArgumentException(string.Format("realized_by: unknown key '{0}' (allowed: kind, pattern)", key));
            }
        }
        if (Array.IndexOf((string[])Kinds, kind) < 0)
        {
            throw new ArgumentException(string.Format("realized_by: kind '{0}' is not one of {1}", kind, string.Join(", ", Kinds)));
        }
        if (kind == "prose-only" && pattern != null)
        {
            throw new ArgumentException("realized_by: a prose-only concept carries no 'pattern'");
        }
        if (kind != "prose-only" && pattern == null)
        {
            throw new ArgumentException(string.Format("realized_by: kind '{0}' requires a 'pattern'", kind));
        }
    }
}
