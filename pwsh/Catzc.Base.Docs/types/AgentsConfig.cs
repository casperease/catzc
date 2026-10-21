/*
---
catzc:
  immutable:
    with_body_sha: "853d85132e75"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
    docs: "[AgentsConfig.cs.md](docs/references/pwsh/catzc-base-docs/types/AgentsConfig.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-CONF-LOADING-CSHARPCONFIGTYPE
      - ADR-REPO-AGENTS-BACKEDBYRULE
      - ADR-REPO-AGENTS-STANDARDWORKER
      - ADR-REPO-AGENTS-ROBOTBODYLIMIT
      - ADR-REPO-AGENTS-CAPABILITYFILE
      - ADR-REPO-AI
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AgentsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "standard", "agents", "roofs", "contracts" };
    private static readonly string[] RequiredKeys = { "standard", "agents" };
    private static readonly string[] RoofKeys = { "agent_body_lines", "capability_lines" };
    private static readonly System.Text.RegularExpressions.Regex ContractRe =
        new System.Text.RegularExpressions.Regex("^" + AdrCodeForm.AnyKind.Cited + "$", System.Text.RegularExpressions.RegexOptions.Compiled);

    public IReadOnlyList<string> contracts { get; } = new[] { "ADR-REPO-AI" };

    // The standard sub-agent for delegated work ([ADR-REPO-AGENTS-STANDARDWORKER](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-standardworker)).
    public string standard { get; }

    // The registered agents, in file order.
    public IReadOnlyList<AgentEntry> agents { get; }

    public int agent_body_lines { get; } = 20;

    public int capability_lines { get; } = 10;

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
        foreach (string key in RequiredKeys)
        {
            if (d == null || !d.Contains(key)) { errors.Add(string.Format("missing required key '{0}'", key)); }
        }

        if (d != null && d.Contains("contracts"))
        {
            contracts = AgentEntry.ReadList(d, "contracts", ContractRe, "a bare ADR code ADR-<CODE>", errors);
            if (contracts.Count == 0) { errors.Add("'contracts' must name at least one contract; leave the key out for the default"); }
        }

        if (d != null && d.Contains("roofs"))
        {
            IDictionary roofs = d["roofs"] as IDictionary;
            if (roofs == null) { errors.Add("roofs must be a mapping of agent_body_lines and capability_lines"); }
            else
            {
                foreach (object k in roofs.Keys)
                {
                    string key = k == null ? null : k.ToString();
                    if (Array.IndexOf(RoofKeys, key) < 0)
                    {
                        errors.Add(string.Format("roofs: unknown key '{0}' (allowed: {1})", key, string.Join(", ", RoofKeys)));
                    }
                }
                int value;
                if (roofs.Contains("agent_body_lines"))
                {
                    if (TryRoof(roofs["agent_body_lines"], out value)) { agent_body_lines = value; }
                    else { errors.Add("roofs: agent_body_lines must be a positive integer"); }
                }
                if (roofs.Contains("capability_lines"))
                {
                    if (TryRoof(roofs["capability_lines"], out value)) { capability_lines = value; }
                    else { errors.Add("roofs: capability_lines must be a positive integer"); }
                }
            }
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

    // A roof is a positive integer, however the YAML reader typed it.
    private static bool TryRoof(object raw, out int value)
    {
        value = 0;
        if (raw == null || raw is bool) { return false; }
        return int.TryParse(raw.ToString(), out value) && value > 0;
    }
}
