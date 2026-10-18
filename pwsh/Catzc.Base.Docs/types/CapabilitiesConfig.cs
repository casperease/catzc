using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

// Rests on [ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml), [ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype) and [ADR-REPO-AGENTS-NOORPHANNOGHOST](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-noorphannoghost).
public sealed class CapabilitiesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "capabilities" };

    // The registered capabilities, in file order ([ADR-REPO-AGENTS-CAPABILITYREGISTERED](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-capabilityregistered)).
    public IReadOnlyList<CapabilityEntry> capabilities { get; }

    public CapabilitiesConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        List<CapabilityEntry> entries = new List<CapabilityEntry>();
        capabilities = entries;

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
        if (d == null || !d.Contains("capabilities")) { errors.Add("missing required key 'capabilities'"); }

        HashSet<string> names = new HashSet<string>(StringComparer.Ordinal);
        if (d != null && d.Contains("capabilities"))
        {
            IList list = d["capabilities"] as IList;
            if (list == null || list.Count == 0)
            {
                errors.Add("capabilities must be a non-empty list of entries");
            }
            else
            {
                for (int i = 0; i < list.Count; i++)
                {
                    IDictionary raw = list[i] as IDictionary;
                    if (raw == null)
                    {
                        errors.Add(string.Format("capabilities[{0}] must be a mapping with a 'name' key", i));
                        continue;
                    }
                    try
                    {
                        CapabilityEntry entry = new CapabilityEntry(raw);
                        if (!names.Add(entry.name))
                        {
                            errors.Add(string.Format("capabilities[{0}]: duplicate entry for capability '{1}'", i, entry.name));
                            continue;
                        }
                        entries.Add(entry);
                    }
                    catch (ArgumentException ex)
                    {
                        foreach (string line in ex.Message.Split('\n'))
                        {
                            errors.Add(string.Format("capabilities[{0}]: {1}", i, line));
                        }
                    }
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("capabilities configuration validation failed:\n" + string.Join("\n", errors));
        }
    }
}
