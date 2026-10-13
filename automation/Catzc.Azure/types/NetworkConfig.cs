// The cross-cutting IP plan (configs/network.yml, [ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)) — the
// single source of truth for vnet / subnet ranges, keyed by azure.yml environment name. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.NetworkConfig), so Get-Config -Config network returns this
// typed record. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException: the top-level
// key 'environments' is required, is the only key, and is a non-empty map of well-formed NetworkEnvironment entries.
// The type checks this file alone. The cross-asset sync with azure.yml
// ([ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2)) joins two configs, so it is the
// quality gate Test-AzureNetworkPlan, not a constructor that reads another config.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

public sealed class NetworkConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The per-environment IP plans, keyed by environment name in file order (a Dictionary enumerates in insertion
    // order when nothing is removed, and this one is never mutated after construction).
    public IReadOnlyDictionary<string, NetworkEnvironment> environments { get; }

    public NetworkConfig(IDictionary d)
    {
        if (d == null || !d.Contains("environments"))
        {
            throw new ArgumentException("network configuration validation failed:\nMissing required top-level key: 'environments'");
        }

        List<string> errors = new List<string>();
        AzureConfig.UnknownKeys(d, new[] { "environments" }, "network.yml", errors);

        Dictionary<string, NetworkEnvironment> map = new Dictionary<string, NetworkEnvironment>(StringComparer.Ordinal);
        environments = map;
        IDictionary raw = d["environments"] as IDictionary;
        if (d["environments"] != null && raw == null)
        {
            errors.Add("'environments' must be a map of environment name -> { vnet_address_space, default_subnet }");
        }
        else if (raw == null || raw.Count == 0)
        {
            errors.Add("environments is empty");
        }
        else
        {
            foreach (object k in raw.Keys)
            {
                string name = AzureConfig.Text(k);
                map[name] = new NetworkEnvironment(name, raw[k] as IDictionary, errors);
            }
        }

        if (errors.Count > 0) { throw new ArgumentException("network configuration validation failed:\n" + string.Join("\n", errors)); }
    }
}
