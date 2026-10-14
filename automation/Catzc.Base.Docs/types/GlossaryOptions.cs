// A glossary source's parameters (the optional configs/glossary.yml `options:` mapping), with every key defaulted:
// a source overrides only what differs ([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)). `checks`
// picks which glossary checks the source's concepts take part in; `scope` and `exclude` bound where its avoided phrasings are scanned; `surfaces` picks which kinds of text
// are read there. The default excludes (external language, generated output, vendored code) are ALWAYS added to a
// source's own, so no source can scan DORA's research text or out/. Scope and exclude globs are repo-relative
// ('/'-separated, no leading '/', no drive, no '..', never a URL —
// [ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)). Mirrors the YAML mapping
// (snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class GlossaryOptions : Catzc.Base.Objects.DictionaryRecord
{
    // The closed set of glossary checks a source may take part in (the structural check always runs).
    public static readonly IReadOnlyList<string> Checks = new[] { "anchored", "single", "avoid", "enforced", "forms" };

    // The closed set of text surfaces the avoided-phrasing scan can read.
    public static readonly IReadOnlyList<string> Surfaces = new[] { "markdown", "comments", "help", "messages" };

    // The default scope: the whole repository.
    public static readonly IReadOnlyList<string> DefaultScope = new[] { "**" };

    // The excludes every source carries, before its own.
    public static readonly IReadOnlyList<string> DefaultExclude = new[]
    {
        "docs/adr/research/**", "docs/references/dora/**", "out/**", "automation/.vendor/**"
    };

    private static readonly Regex DriveRe = new Regex("^[A-Za-z]:", RegexOptions.Compiled);

    // The glossary checks this source's concepts take part in. Default: all of Checks.
    public IReadOnlyList<string> checks { get; }

    // Where this source's avoided phrasings and qualified forms are scanned. Default: DefaultScope.
    public IReadOnlyList<string> scope { get; }

    // DefaultExclude followed by the source's own excludes (deduplicated, in order).
    public IReadOnlyList<string> exclude { get; }

    // The text surfaces the scan reads. Default: all of Surfaces.
    public IReadOnlyList<string> surfaces { get; }

    public GlossaryOptions(IDictionary d)
    {
        List<string> errors = new List<string>();

        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (key != "checks" && key != "scope" && key != "exclude" && key != "surfaces")
                {
                    errors.Add(string.Format("options: unknown key '{0}' (allowed: checks, scope, exclude, surfaces)", key));
                }
            }
        }

        checks = ClosedList(d, "checks", Checks, errors);
        surfaces = ClosedList(d, "surfaces", Surfaces, errors);
        scope = (d != null && d.Contains("scope")) ? GlobList(d, "scope", errors) : DefaultScope;

        List<string> excludes = new List<string>(DefaultExclude);
        if (d != null && d.Contains("exclude"))
        {
            foreach (string glob in GlobList(d, "exclude", errors))
            {
                if (!excludes.Contains(glob)) { excludes.Add(glob); }
            }
        }
        exclude = excludes;

        if (errors.Count > 0) { throw new ArgumentException(string.Join("; ", errors)); }
    }

    // A list option restricted to a closed set; absent -> the whole set. An explicit empty list is allowed (a source
    // that opts out of every check still gets the structural check).
    private static IReadOnlyList<string> ClosedList(IDictionary d, string key, IReadOnlyList<string> allowed, List<string> errors)
    {
        if (d == null || !d.Contains(key)) { return allowed; }
        List<string> values = new List<string>();
        foreach (string v in StrArr(d, key))
        {
            if (Array.IndexOf((string[])allowed, v) < 0)
            {
                errors.Add(string.Format("options.{0}: '{1}' is not one of {2}", key, v, string.Join(", ", allowed)));
            }
            else if (!values.Contains(v)) { values.Add(v); }
        }
        return values;
    }

    private static IReadOnlyList<string> GlobList(IDictionary d, string key, List<string> errors)
    {
        List<string> globs = new List<string>();
        foreach (string raw in StrArr(d, key))
        {
            string g = raw.Trim();
            if (g.Length == 0 || g.StartsWith("/") || g.Contains("\\") || g.Contains("://") || DriveRe.IsMatch(g)
                || Array.IndexOf(g.Split('/'), "..") >= 0)
            {
                errors.Add(string.Format("options.{0}: '{1}' must be a repo-relative '/'-separated glob", key, raw));
                continue;
            }
            globs.Add(g);
        }
        return globs;
    }
}
