// One entry of configs/output-formats.yml: a declared kind of file a producer writes under the output root
// ([ADR-REPO-OUTFMT#1](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt1)). Constructing one MAPS and
// VALIDATES the entry, collecting every violation into one throw:
//   - the id (its map key) is kebab-case;
//   - only the keys patterns, target, producer, audience, validator, limits;
//   - `patterns` is a non-empty list of output-root-relative globs in the OutputPattern grammar ('*' and '?'
//     inside one segment, '**' any depth, '{stamp}' one stamped folder);
//   - `target` is 'file' (the default) or 'folder' (the pattern names a folder, checked as one unit);
//   - `producer` (the function or script that writes it) and `audience` (who opens it, with what) are required;
//   - `validator` is a map with a known `kind` and only that kind's parameters, its required ones present
//     ([ADR-REPO-OUTFMT#3](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt3));
//   - `limits` holds only known limit names, each a positive whole number
//     ([ADR-REPO-OUTFMT#5](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt5)).
// That no two formats' patterns overlap spans entries, so OutputFormatsConfig checks it. Mirrors the YAML mapping
// (snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

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
    private static readonly string[] AllowedKeys = { "patterns", "target", "producer", "audience", "validator", "limits" };
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
