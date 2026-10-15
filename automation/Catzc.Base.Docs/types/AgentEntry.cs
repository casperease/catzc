// One entry of configs/agents.yml's `agents` list: a sub-agent definition (.claude/agents/<name>.md) with the ADR rules that support it...
// [ADR-REPO-AGENTS#2](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents2),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AgentEntry.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class AgentEntry : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "name", "supported_by", "checks" };
    private static readonly Regex NameRe = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$", RegexOptions.Compiled);
    private static readonly Regex CitationRe = new Regex("^ADR-[A-Z]+(-[A-Z]+)*#[1-9][0-9]*$", RegexOptions.Compiled);
    private static readonly Regex CommandRe = new Regex("^[A-Z][a-z]+-[A-Za-z0-9]+$", RegexOptions.Compiled);

    // The agent's name: the file .claude/agents/<name>.md and its front-matter name.
    public string name { get; }

    // The rule citations (ADR-<CODE>#<n>) that justify the agent, in file order.
    public IReadOnlyList<string> supported_by { get; }

    // The gate and check functions the agent runs or guards, in file order; empty when it has none.
    public IReadOnlyList<string> checks { get; }

    public AgentEntry(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("must be a mapping with a 'name' key"); }
        List<string> errors = new List<string>();

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        name = OptStr(d, "name");
        if (name == null) { errors.Add("'name' is required and must be non-empty"); }
        else if (!NameRe.IsMatch(name)) { errors.Add(string.Format("name '{0}' must be kebab-case", name)); }

        supported_by = ReadList(d, "supported_by", CitationRe, "a rule citation ADR-<CODE>#<n>", errors);
        if (d.Contains("supported_by") && supported_by.Count == 0)
        {
            errors.Add("'supported_by' must cite at least one rule");
        }

        checks = ReadList(d, "checks", CommandRe, "a Verb-Noun command name", errors);

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    // Reads a required list of distinct strings that each match the pattern, collecting every violation.
    private static IReadOnlyList<string> ReadList(IDictionary d, string key, Regex pattern, string what, List<string> errors)
    {
        List<string> values = new List<string>();
        if (!d.Contains(key))
        {
            errors.Add(string.Format("'{0}' is required", key));
            return values;
        }
        object raw = d[key];
        if (raw == null) { return values; }
        IList list = raw as IList;
        if (list == null || raw is string)
        {
            errors.Add(string.Format("'{0}' must be a list", key));
            return values;
        }
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (object item in list)
        {
            string value = item == null ? null : item.ToString();
            if (value == null || !pattern.IsMatch(value))
            {
                errors.Add(string.Format("{0} entry '{1}' must be {2}", key, value, what));
                continue;
            }
            if (!seen.Add(value))
            {
                errors.Add(string.Format("{0} entry '{1}' is repeated", key, value));
                continue;
            }
            values.Add(value);
        }
        return values;
    }
}
