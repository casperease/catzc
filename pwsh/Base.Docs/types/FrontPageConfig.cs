using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

// The repository's front page: its target, its title block, and its sections in page order.
public sealed class FrontPageConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string target { get; }

    public string title { get; }

    public string tagline { get; }

    public IReadOnlyList<FrontPageBadge> badges { get; }

    public IReadOnlyList<FrontPageSection> sections { get; }

    // The bold line the page closes with.
    public string closing { get; }

    private static readonly string[] AllowedKeys = { "target", "title", "tagline", "badges", "sections", "closing" };

    public FrontPageConfig(IDictionary raw)
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

        target = Text(raw, "target", errors);
        title = Text(raw, "title", errors);
        tagline = Text(raw, "tagline", errors);
        closing = Text(raw, "closing", errors);

        List<FrontPageBadge> badgeList = new List<FrontPageBadge>();
        foreach (IDictionary entry in Entries(raw, "badges", errors))
        {
            try { badgeList.Add(new FrontPageBadge(entry)); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }
        badges = badgeList;

        List<FrontPageSection> sectionList = new List<FrontPageSection>();
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (IDictionary entry in Entries(raw, "sections", errors))
        {
            FrontPageSection s;
            try { s = new FrontPageSection(entry); }
            catch (ArgumentException ex) { errors.Add(ex.Message); continue; }
            if (!seen.Add(s.id)) { errors.Add(string.Format("duplicate section id '{0}'", s.id)); continue; }
            sectionList.Add(s);
        }
        sections = sectionList;

        if (errors.Count == 0 && sections.Count == 0)
        {
            errors.Add("frontpage config requires at least one section");
        }
        foreach (FrontPageBadge b in badges)
        {
            bool isUrl = b.to.Contains("://");
            if (!isUrl && !seen.Contains(b.to))
            {
                errors.Add(string.Format("badge '{0}' leads to '{1}', which is neither a URL nor a section id", b.label, b.to));
            }
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("frontpage config validation failed:\n" + string.Join("\n", errors));
        }
    }

    // The section a badge or a renderer names by its id.
    public FrontPageSection Section(string id)
    {
        foreach (FrontPageSection s in sections) { if (s.id == id) { return s; } }
        return null;
    }

    private static string Text(IDictionary raw, string key, List<string> errors)
    {
        object v = (raw != null && raw.Contains(key)) ? raw[key] : null;
        if (v == null || string.IsNullOrWhiteSpace(v.ToString())) { errors.Add(string.Format("'{0}' is required", key)); return null; }
        return v.ToString();
    }

    private static IEnumerable<IDictionary> Entries(IDictionary raw, string key, List<string> errors)
    {
        object obj = (raw != null && raw.Contains(key)) ? raw[key] : null;
        if (obj == null) { yield break; }
        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string) { errors.Add(string.Format("'{0}' must be a list", key)); yield break; }
        foreach (object item in seq)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add(string.Format("each '{0}' entry must be a mapping", key)); continue; }
            yield return entry;
        }
    }
}
