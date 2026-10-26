using System;
using System.Collections;
using System.Collections.Generic;

using Catzc.Base.Reports;

namespace Catzc.Base.Drs;

// drs-checks.yml and the one declaration of its defaults: every key is optional, and an omitted key behaves exactly like its default.
public sealed class DrsChecksConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "engine_neutrality", "citation_graph", "dora_coverage", "code_language" };

    public DrsNeutralityCheck engine_neutrality { get; }
    public DrsCheck citation_graph { get; }
    public DrsDoraCheck dora_coverage { get; }
    public DrsCodeLanguageCheck code_language { get; }

    public DrsChecksConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null) { CheckKeys(raw, AllowedKeys, "drs-checks", errors); }

        engine_neutrality = new DrsNeutralityCheck(Section(raw, "engine_neutrality", errors), "engine_neutrality", errors);
        citation_graph = new DrsCheck(Section(raw, "citation_graph", errors), "citation_graph", errors);
        dora_coverage = new DrsDoraCheck(Section(raw, "dora_coverage", errors), "dora_coverage", errors);
        code_language = new DrsCodeLanguageCheck(Section(raw, "code_language", errors), "code_language", errors);

        if (errors.Count > 0)
        {
            throw new ArgumentException("drs-checks.yml is invalid:\n  - " + string.Join("\n  - ", errors));
        }
    }

    // A check's mode, parsed by the one CheckModes parser; its error is prefixed with the check's key, like every error here.
    internal static CheckMode ParseMode(IDictionary raw, string where, List<string> errors)
    {
        CheckMode mode = CheckModes.Parse(raw, out string error);
        if (error != null) { errors.Add(where + ": " + error); }
        return mode;
    }

    internal static void CheckKeys(IDictionary map, string[] allowed, string where, List<string> errors)
    {
        foreach (object key in map.Keys)
        {
            string k = key == null ? string.Empty : key.ToString();
            if (Array.IndexOf(allowed, k) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", where, k, string.Join(", ", allowed)));
            }
        }
    }

    private static IDictionary Section(IDictionary raw, string key, List<string> errors)
    {
        if (raw == null || !raw.Contains(key) || raw[key] == null) { return null; }
        IDictionary section = raw[key] as IDictionary;
        if (section == null) { errors.Add(string.Format("{0}: must be a mapping", key)); }
        return section;
    }
}
