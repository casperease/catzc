/*
---
catzc:
  immutable:
    with_body_sha: e85012d0c5fd
  edges:
    docs: "[OutputFormat.cs.md](../../../docs/references/pwsh/catzc-base-reports/types/OutputFormat.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-OUTFMT-OUTPUTFORMAT
      - ADR-REPO-OUTFMT-VALIDATORISCODE
      - ADR-REPO-OUTFMT-LIMITSINCATALOGUE
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;

namespace Catzc.Base.Reports;

public sealed class OutputFormat : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly Regex KebabCase = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex CommandName = new Regex("^[A-Z][a-z]+-[A-Za-z][A-Za-z0-9]*$");
    private static readonly string[] AllowedKeys =
        { "area", "keep", "max_age", "in_pipeline", "patterns", "target", "producer", "audience", "validator", "limits" };
    private static readonly Regex Age = new Regex("^(?<n>[1-9][0-9]*)(?<unit>[dh])$");

    // Area -> its retention defaults { keep (null = all), max_age (null = none) }; a format overrides either. The closed set of areas.
    private static readonly Dictionary<string, Tuple<int?, TimeSpan?>> Areas = new Dictionary<string, Tuple<int?, TimeSpan?>>(StringComparer.Ordinal)
    {
        { "run",     Tuple.Create<int?, TimeSpan?>(10, null) },
        { "build",   Tuple.Create<int?, TimeSpan?>(1, null) },
        { "cache",   Tuple.Create<int?, TimeSpan?>(null, null) },
        { "review",  Tuple.Create<int?, TimeSpan?>(null, null) },
        { "session", Tuple.Create<int?, TimeSpan?>(null, TimeSpan.FromDays(7)) },
        { "log",     Tuple.Create<int?, TimeSpan?>(null, TimeSpan.FromDays(7)) },
    };
    private static readonly string[] Targets = { "file", "folder" };
    private static readonly string[] LimitNames =
        { "width", "height", "min_width", "max_width", "min_height", "max_height", "min_pages", "max_bytes" };

    // Validator kind -> { allowed parameters, required parameters }. The closed set of kinds.
    private static readonly Dictionary<string, string[][]> Kinds = new Dictionary<string, string[][]>(StringComparer.Ordinal)
    {
        { "png",            new[] { new string[0], new string[0] } },
        { "drawio-png",     new[] { new string[0], new string[0] } },
        { "drawio-model",   new[] { new string[0], new string[0] } },
        { "pdf",            new[] { new string[0], new string[0] } },
        { "json",           new[] { new[] { "required_keys" }, new string[0] } },
        { "csv",            new[] { new[] { "columns" }, new string[0] } },
        { "md",             new[] { new[] { "table_columns", "status_column", "statuses" }, new string[0] } },
        { "nunit-xml",      new[] { new string[0], new string[0] } },
        { "zip",            new[] { new[] { "required_entries" }, new string[0] } },
        { "powershell",     new[] { new string[0], new string[0] } },
        { "text",           new[] { new string[0], new string[0] } },
        { "latest-pointer", new[] { new string[0], new string[0] } },
        { "delegate",       new[] { new[] { "command" }, new[] { "command" } } },
    };

    // The format id (its map key in output-formats.yml).
    public string id { get; }

    // The class of output, which sets the retention defaults: run, build, cache, review, session or log.
    public string area { get; }

    // How many to keep: the newest stamps of a stamped pattern, else the newest files; null keeps all.
    public int? keep { get; }

    // The oldest a stamp or file may be before it goes; null never ages out.
    public TimeSpan? max_age { get; }

    // Whether retention applies in a pipeline, whose staging directory is fresh for every run.
    public bool in_pipeline { get; }

    // Output-root-relative globs, in declaration order.
    public ReadOnlyCollection<string> patterns { get; }

    // 'file' or 'folder'.
    public string target { get; }

    // The function or script that writes this format.
    public string producer { get; }

    // Who opens this format, and with what.
    public string audience { get; }

    // The validator kind, one of the closed set.
    public string validator_kind { get; }

    // The validator's parameters (string or string list values); empty when the kind takes none.
    public ReadOnlyDictionary<string, object> validator_parameters { get; }

    // Limit name -> value; empty when the format declares none.
    public ReadOnlyDictionary<string, int> limits { get; }

    public OutputFormat(string formatId, object raw)
    {
        List<string> errors = new List<string>();
        string label = string.Format("format '{0}'", formatId);
        if (formatId == null || !KebabCase.IsMatch(formatId)) { errors.Add(label + ": the id must be kebab-case"); }

        IDictionary d = raw as IDictionary;
        if (d == null) { throw new ArgumentException(label + ": must be a map of patterns, producer, audience, validator [, target, limits]"); }

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", label, key, string.Join(", ", AllowedKeys)));
            }
        }

        id = formatId;
        area = OptStr(d, "area");
        Tuple<int?, TimeSpan?> defaults = null;
        if (area == null || !Areas.TryGetValue(area, out defaults))
        {
            errors.Add(string.Format("{0}: area '{1}' is unknown (known: {2})", label, area, string.Join(", ", Areas.Keys)));
            defaults = Tuple.Create<int?, TimeSpan?>(null, null);
        }
        keep = d.Contains("keep") ? ReadKeep(d["keep"], label, errors) : defaults.Item1;
        max_age = d.Contains("max_age") ? ReadAge(d["max_age"], label, errors) : defaults.Item2;
        string inPipeline = OptStr(d, "in_pipeline");
        in_pipeline = inPipeline != null && inPipeline.Equals("true", StringComparison.OrdinalIgnoreCase);
        if (inPipeline != null && !in_pipeline && !inPipeline.Equals("false", StringComparison.OrdinalIgnoreCase))
        {
            errors.Add(string.Format("{0}: in_pipeline '{1}' must be true or false", label, inPipeline));
        }
        patterns = new ReadOnlyCollection<string>(ReadPatterns(d, label, errors));
        target = OptStr(d, "target") ?? "file";
        if (Array.IndexOf(Targets, target) < 0) { errors.Add(string.Format("{0}: target '{1}' must be 'file' or 'folder'", label, target)); }
        producer = OptStr(d, "producer");
        if (producer == null) { errors.Add(label + ": producer is required (the function or script that writes it)"); }
        audience = OptStr(d, "audience");
        if (audience == null) { errors.Add(label + ": audience is required (who opens it, and with what)"); }

        string kind;
        validator_parameters = new ReadOnlyDictionary<string, object>(ReadValidator(d, label, errors, out kind));
        validator_kind = kind;
        limits = new ReadOnlyDictionary<string, int>(ReadLimits(d, label, errors));

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    // A positive whole number, or 'all'.
    private static int? ReadKeep(object raw, string label, List<string> errors)
    {
        string text = raw == null ? null : raw.ToString();
        if (text == "all") { return null; }
        int value;
        if (text != null && int.TryParse(text, out value) && value > 0) { return value; }
        errors.Add(string.Format("{0}: keep '{1}' must be a positive whole number or 'all'", label, text));
        return null;
    }

    // '<n>d' or '<n>h', or 'none'.
    private static TimeSpan? ReadAge(object raw, string label, List<string> errors)
    {
        string text = raw == null ? null : raw.ToString();
        if (text == "none") { return null; }
        Match match = text == null ? Match.Empty : Age.Match(text);
        if (match.Success)
        {
            int n = int.Parse(match.Groups["n"].Value);
            return match.Groups["unit"].Value == "d" ? TimeSpan.FromDays(n) : TimeSpan.FromHours(n);
        }
        errors.Add(string.Format("{0}: max_age '{1}' must be '<n>d', '<n>h' or 'none'", label, text));
        return null;
    }

    private static List<string> ReadPatterns(IDictionary d, string label, List<string> errors)
    {
        List<string> list = new List<string>(StrArr(d, "patterns"));
        if (list.Count == 0) { errors.Add(label + ": patterns must list at least one output-root-relative glob"); }
        foreach (string pattern in list)
        {
            try { OutputPattern.Parse(pattern); }
            catch (ArgumentException ex)
            {
                foreach (string line in ex.Message.Split('\n')) { errors.Add(label + ": " + line); }
            }
        }
        return list;
    }

    private static Dictionary<string, object> ReadValidator(IDictionary d, string label, List<string> errors, out string kind)
    {
        Dictionary<string, object> parameters = new Dictionary<string, object>(StringComparer.Ordinal);
        kind = null;
        IDictionary v = (d.Contains("validator") ? d["validator"] : null) as IDictionary;
        if (v == null)
        {
            errors.Add(label + ": validator is required, as a map with a 'kind'");
            return parameters;
        }

        kind = OptStr(v, "kind");
        string[][] shape;
        if (kind == null || !Kinds.TryGetValue(kind, out shape))
        {
            errors.Add(string.Format("{0}: validator kind '{1}' is unknown (known: {2})", label, kind, string.Join(", ", Kinds.Keys)));
            return parameters;
        }

        foreach (object k in v.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key == "kind") { continue; }
            if (Array.IndexOf(shape[0], key) < 0)
            {
                errors.Add(string.Format("{0}: validator kind '{1}' takes no parameter '{2}'", label, kind, key));
                continue;
            }
            object value = v[k];
            if (value is IList) { parameters[key] = new ReadOnlyCollection<string>(new List<string>(StrArr(v, key))); }
            else { parameters[key] = value == null ? null : value.ToString(); }
        }
        foreach (string required in shape[1])
        {
            if (!parameters.ContainsKey(required) || parameters[required] == null)
            {
                errors.Add(string.Format("{0}: validator kind '{1}' requires '{2}'", label, kind, required));
            }
        }
        if (kind == "delegate" && parameters.ContainsKey("command") && parameters["command"] is string
            && !CommandName.IsMatch((string)parameters["command"]))
        {
            errors.Add(string.Format("{0}: validator command '{1}' must be a Verb-Noun command name", label, parameters["command"]));
        }
        if (kind == "md" && parameters.ContainsKey("statuses") != parameters.ContainsKey("status_column"))
        {
            errors.Add(label + ": validator kind 'md' takes 'statuses' and 'status_column' together");
        }
        return parameters;
    }

    private static Dictionary<string, int> ReadLimits(IDictionary d, string label, List<string> errors)
    {
        Dictionary<string, int> map = new Dictionary<string, int>(StringComparer.Ordinal);
        object rawLimits = d.Contains("limits") ? d["limits"] : null;
        if (rawLimits == null) { return map; }
        IDictionary l = rawLimits as IDictionary;
        if (l == null)
        {
            errors.Add(label + ": limits must be a map of <limit>: <positive whole number>");
            return map;
        }
        foreach (object k in l.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (Array.IndexOf(LimitNames, name) < 0)
            {
                errors.Add(string.Format("{0}: unknown limit '{1}' (known: {2})", label, name, string.Join(", ", LimitNames)));
                continue;
            }
            int value;
            if (l[k] == null || !int.TryParse(l[k].ToString(), out value) || value <= 0)
            {
                errors.Add(string.Format("{0}: limit '{1}' must be a positive whole number", label, name));
                continue;
            }
            map[name] = value;
        }
        return map;
    }
}
