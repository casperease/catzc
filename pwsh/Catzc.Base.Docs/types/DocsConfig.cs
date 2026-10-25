/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class DocsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Glob-derived source conventions, in registry order.
    public IReadOnlyList<DocPattern> patterns { get; }

    // Explicit folder->source README copy-ins, in registry order.
    public IReadOnlyList<DocMapping> mappings { get; }

    // Pattern-matched folders allowed to have no source article, each with its reason; empty by default.
    public IReadOnlyList<DocWithoutArticle> without_article { get; }

    private static readonly string[] AllowedKeys = { "patterns", "mappings", "without_article" };

    public DocsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string topKey = key == null ? string.Empty : key.ToString();
                if (Array.IndexOf(AllowedKeys, topKey) < 0)
                {
                    errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", topKey, string.Join(", ", AllowedKeys)));
                }
            }
        }

        patterns = ParsePatterns(raw, errors);
        mappings = ParseMappings(raw, errors);
        without_article = ParseWithoutArticle(raw, errors);

        if (errors.Count == 0 && patterns.Count == 0 && mappings.Count == 0)
        {
            errors.Add("readme config requires at least one 'patterns' or 'mappings' entry");
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("readme config validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static IReadOnlyList<DocPattern> ParsePatterns(IDictionary raw, List<string> errors)
    {
        List<DocPattern> list = new List<DocPattern>();
        object obj = (raw != null && raw.Contains("patterns")) ? raw["patterns"] : null;
        if (obj == null) { return list; }

        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string) { errors.Add("'patterns' must be a list"); return list; }

        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each 'patterns' entry must be a mapping"); continue; }
            try { list.Add(new DocPattern(entry)); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }
        return list;
    }

    private static IReadOnlyList<DocMapping> ParseMappings(IDictionary raw, List<string> errors)
    {
        List<DocMapping> list = new List<DocMapping>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        object obj = (raw != null && raw.Contains("mappings")) ? raw["mappings"] : null;
        if (obj == null) { return list; }

        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string) { errors.Add("'mappings' must be a list"); return list; }

        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each 'mappings' entry must be a mapping"); continue; }

            DocMapping m;
            try { m = new DocMapping(entry); }
            catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

            if (!seen.Add(m.folder)) { errors.Add(string.Format("duplicate target folder '{0}'", m.folder)); continue; }
            list.Add(m);
        }
        return list;
    }

    private static IReadOnlyList<DocWithoutArticle> ParseWithoutArticle(IDictionary raw, List<string> errors)
    {
        List<DocWithoutArticle> list = new List<DocWithoutArticle>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        object obj = (raw != null && raw.Contains("without_article")) ? raw["without_article"] : null;
        if (obj == null) { return list; }

        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string) { errors.Add("'without_article' must be a list"); return list; }

        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each 'without_article' entry must be a mapping"); continue; }

            DocWithoutArticle w;
            try { w = new DocWithoutArticle(entry); }
            catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

            if (!seen.Add(w.folder)) { errors.Add(string.Format("duplicate without_article folder '{0}'", w.folder)); continue; }
            list.Add(w);
        }
        return list;
    }
}
