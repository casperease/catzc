using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

// The repository's filters: named views over the hard model (tracks, aspects, generated targets), in declaration order. A filter is a
// union of what its selectors select, and two filters may claim the same file; a filter never redefines a track or an aspect.
public sealed class FiltersConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "filters" };

    public IReadOnlyList<RepositoryFilter> filters { get; }

    public FiltersConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<RepositoryFilter> list = new List<RepositoryFilter>();
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }
            object value = raw.Contains("filters") ? raw["filters"] : null;
            IList items = value as IList;
            if (value != null && (items == null || value is string))
            {
                errors.Add("filters must be a list of { name, select }");
            }
            else if (items != null)
            {
                foreach (object item in items)
                {
                    try
                    {
                        RepositoryFilter filter = new RepositoryFilter(item as IDictionary);
                        if (!seen.Add(filter.name)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}' is declared twice", filter.name)); }
                        else { list.Add(filter); }
                    }
                    catch (ArgumentException ex) { errors.Add(ex.Message); }
                }
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        filters = list.AsReadOnly();
    }
}

// One filter: its name (a lamp's id, lower snake case) and its selectors, each one of the closed selector kinds.
public sealed class RepositoryFilter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Selector kinds that take an argument after the first '.', and those that stand alone.
    public static readonly string[] ArgumentKinds = { "aspect", "track", "track_type", "glob" };
    public static readonly string[] BareKinds = { "generated", "root_config" };
    private static readonly Regex FilterName = new Regex("^[a-z][a-z0-9_]*$");

    public string name { get; }

    public IReadOnlyList<string> select { get; }

    public RepositoryFilter(IDictionary entry)
    {
        if (entry == null) { throw new ArgumentException("a filter must be a mapping of name and select"); }
        List<string> errors = new List<string>();
        foreach (object key in entry.Keys)
        {
            string k = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (k != "name" && k != "select") { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter: unknown key '{0}' (allowed: name, select)", k)); }
        }
        name = entry.Contains("name") ? entry["name"] as string : null;
        if (name == null || !FilterName.IsMatch(name)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter name '{0}' must be lower snake case", name)); }
        List<string> selectors = new List<string>();
        IList items = entry.Contains("select") ? entry["select"] as IList : null;
        if (items == null || entry["select"] is string || items.Count == 0) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}' must select a non-empty list", name)); }
        else
        {
            foreach (object item in items)
            {
                string selector = item as string;
                string problem = Problem(selector);
                if (problem != null) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}': {1}", name, problem)); }
                else { selectors.Add(selector); }
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        select = selectors.AsReadOnly();
    }

    // The selector's kind: the part before its first '.', or the whole selector for a bare kind.
    public static string KindOf(string selector)
    {
        int dot = selector.IndexOf('.');
        return dot < 0 ? selector : selector.Substring(0, dot);
    }

    // The selector's argument: everything after its first '.'; empty for a bare kind.
    public static string ArgumentOf(string selector)
    {
        int dot = selector.IndexOf('.');
        return dot < 0 ? string.Empty : selector.Substring(dot + 1);
    }

    private static string Problem(string selector)
    {
        if (string.IsNullOrWhiteSpace(selector)) { return "a selector must be a non-empty string"; }
        string kind = KindOf(selector);
        if (Array.IndexOf(BareKinds, selector) >= 0) { return null; }
        if (Array.IndexOf(ArgumentKinds, kind) < 0)
        {
            return string.Format(CultureInfo.InvariantCulture, "selector '{0}' is no known kind (kinds: {1}, {2})", selector,
                string.Join(", ", ArgumentKinds), string.Join(", ", BareKinds));
        }
        if (ArgumentOf(selector).Length == 0) { return string.Format(CultureInfo.InvariantCulture, "selector '{0}' names nothing after '{1}.'", selector, kind); }
        return null;
    }
}
