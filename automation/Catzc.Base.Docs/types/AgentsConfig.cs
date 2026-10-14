// The sub-agent registry (configs/agents.yml): one entry per sub-agent definition under .claude/agents/, with the
// ADR rules that support it and the checks it runs or guards, plus the one standard agent
// ([ADR-REPO-AGENTS#2](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents2),
// [ADR-REPO-AGENTS#4](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents4)). Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AgentsConfig), so Get-Config -Config agents returns
// this typed record ([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)).
// Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the top-level keys standard and agents, both required;
//   - agents is a non-empty LIST of well-formed AgentEntry mappings with distinct names;
//   - standard names one of the entries.
// The cross-checks against the agent files, the rule ids, the commands, and .claude/CLAUDE.md are the quality gate
// Test-AgentDefinitions.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AgentsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "standard", "agents" };

    // The standard sub-agent for delegated work (ADR-REPO-AGENTS#4).
    public string standard { get; }

    // The registered agents, in file order.
    public IReadOnlyList<AgentEntry> agents { get; }

    public AgentsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        List<AgentEntry> entries = new List<AgentEntry>();
        agents = entries;

        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }
        foreach (string key in AllowedKeys)
        {
            if (d == null || !d.Contains(key)) { errors.Add(string.Format("missing required key '{0}'", key)); }
        }

        HashSet<string> names = new HashSet<string>(StringComparer.Ordinal);
        if (d != null && d.Contains("agents"))
        {
            IList list = d["agents"] as IList;
            if (list == null || list.Count == 0)
            {
                errors.Add("agents must be a non-empty list of entries");
            }
            else
            {
                for (int i = 0; i < list.Count; i++)
                {
                    IDictionary raw = list[i] as IDictionary;
                    if (raw == null)
                    {
                        errors.Add(string.Format("agents[{0}] must be a mapping with a 'name' key", i));
                        continue;
                    }
                    try
                    {
                        AgentEntry entry = new AgentEntry(raw);
                        if (!names.Add(entry.name))
                        {
                            errors.Add(string.Format("agents[{0}]: duplicate entry for agent '{1}'", i, entry.name));
                            continue;
                        }
                        entries.Add(entry);
                    }
                    catch (ArgumentException ex)
                    {
                        foreach (string line in ex.Message.Split('\n'))
                        {
                            errors.Add(string.Format("agents[{0}]: {1}", i, line));
                        }
                    }
                }
            }
        }

        if (d != null && d.Contains("standard"))
        {
            standard = OptStr(d, "standard");
            if (standard == null) { errors.Add("standard is empty"); }
            else if (names.Count > 0 && !names.Contains(standard))
            {
                errors.Add(string.Format("standard '{0}' names no entry in agents", standard));
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("agents configuration validation failed:\n" + string.Join("\n", errors));
        }
    }
}
