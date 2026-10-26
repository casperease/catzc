/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-globs/types/FiltersConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

// Named views over the hard model, in declaration order; a filter never redefines a track or an aspect.
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

// One filter: a lamp id in lower snake case, an optional title, and its selectors of the closed kinds.
public sealed class RepositoryFilter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Selector kinds that take an argument after the first '.', and those that stand alone.
    public static readonly string[] ArgumentKinds = { "aspect", "track", "track_type", "kind", "glob" };
    public static readonly string[] BareKinds = { "generated", "root_config" };
    private static readonly Regex FilterName = new Regex("^[a-z][a-z0-9_]*$");

    public string name { get; }

    public string title { get; }

    public IReadOnlyList<string> select { get; }

    // The file extensions the selected sets are narrowed to ('.ps1'), so a filter can be a part of an aspect; empty keeps them whole.
    public IReadOnlyList<string> extensions { get; }

    // Selectors whose files the filter leaves out, so a track that owns its files as their primary home is not claimed twice.
    public IReadOnlyList<string> except { get; }

    private static readonly Regex Extension = new Regex("^\\.[A-Za-z0-9]+$");

    public RepositoryFilter(IDictionary entry)
    {
        if (entry == null) { throw new ArgumentException("a filter must be a mapping of name and select"); }
        List<string> errors = new List<string>();
        foreach (object key in entry.Keys)
        {
            string k = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (k != "name" && k != "title" && k != "select" && k != "extensions" && k != "except") { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter: unknown key '{0}' (allowed: name, title, select, extensions, except)", k)); }
        }
        List<string> excepted = new List<string>();
        if (entry.Contains("except"))
        {
            IList rawExcept = entry["except"] as IList;
            if (rawExcept == null || entry["except"] is string) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}': except must be a list of selectors", entry.Contains("name") ? entry["name"] : null)); }
            else
            {
                foreach (object item in rawExcept)
                {
                    string selector = item as string;
                    string problem = Problem(selector);
                    if (problem != null) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}' except: {1}", entry.Contains("name") ? entry["name"] : null, problem)); }
                    else { excepted.Add(selector); }
                }
            }
        }
        except = excepted.AsReadOnly();
        List<string> narrowed = new List<string>();
        if (entry.Contains("extensions"))
        {
            IList rawExtensions = entry["extensions"] as IList;
            if (rawExtensions == null || entry["extensions"] is string) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}': extensions must be a list", entry.Contains("name") ? entry["name"] : null)); }
            else
            {
                foreach (object item in rawExtensions)
                {
                    string extension = item as string;
                    if (extension == null || !Extension.IsMatch(extension)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}': extension '{1}' must be a dot and letters or digits, such as '.ps1'", entry.Contains("name") ? entry["name"] : null, item)); }
                    else { narrowed.Add(extension); }
                }
            }
        }
        extensions = narrowed.AsReadOnly();
        name = entry.Contains("name") ? entry["name"] as string : null;
        object rawTitle = entry.Contains("title") ? entry["title"] : null;
        if (rawTitle != null && !(rawTitle is string)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "filter '{0}': title must be a string", name)); }
        title = rawTitle as string ?? string.Empty;
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
