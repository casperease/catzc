// The cross-cutting IP plan (configs/network.yml, [ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)) — the
// single source of truth for vnet / subnet ranges, keyed by azure.yml environment name. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.NetworkConfig), so Get-Config -Config network returns this
// typed record. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - the top-level key 'environments' is required, is the only key, and is a non-empty map of well-formed
//     NetworkEnvironment entries;
//   - cross-asset sync with azure.yml ([ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2)):
//     every network environment is a defined azure.yml environment (no ghost plan), and every STANDARD azure.yml
//     environment has a network entry — per-subscription environments (nsub/psub) are exempt, they carry no vnet
//     ([ADR-AZ-NETWORK#4](/docs/adr/azure/azure-network-model.md#rule-adr-az-network4)).
// The one-argument constructor (the Get-Config registry path) reads the azure config through Get-Config in the
// calling PowerShell session — the join the ADR puts at load; the two-argument constructor takes the AzureConfig
// to check against, so logic tests stay hermetic.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;

namespace Catzc.Azure;

public sealed class NetworkConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The per-environment IP plans, keyed by environment name in file order (a Dictionary enumerates in insertion
    // order when nothing is removed, and this one is never mutated after construction).
    public IReadOnlyDictionary<string, NetworkEnvironment> environments { get; }

    // Loads and validates the plan against the session's azure config (Get-Config -Config azure).
    public NetworkConfig(IDictionary d) : this(d, LoadAzure()) { }

    // Loads and validates the plan against the given azure config.
    public NetworkConfig(IDictionary d, AzureConfig azure)
    {
        if (d == null || !d.Contains("environments"))
        {
            throw new ArgumentException("network configuration validation failed:\nMissing required top-level key: 'environments'");
        }
        if (azure == null) { throw new ArgumentException("network configuration validation failed:\nno azure config to check the plan against"); }

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

        string azureNames = string.Join(", ", azure.environments.Keys);
        foreach (string name in map.Keys)
        {
            if (!azure.environments.ContainsKey(name))
            {
                errors.Add(string.Format("network environment '{0}' is not a defined azure.yml environment (valid: {1})", name, azureNames));
            }
        }
        foreach (AzureEnvironmentRecord environment in azure.environments.Values)
        {
            if (!environment.per_subscription && !map.ContainsKey(environment.name))
            {
                errors.Add(string.Format("azure.yml environment '{0}' has no network entry in network.yml", environment.name));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException("network configuration validation failed:\n" + string.Join("\n", errors)); }
    }

    // The session's azure config, read through the one config reader in the calling PowerShell session.
    private static AzureConfig LoadAzure()
    {
        foreach (PSObject item in ScriptBlock.Create("Get-Config -Config azure").Invoke())
        {
            AzureConfig azure = item == null ? null : item.BaseObject as AzureConfig;
            if (azure != null) { return azure; }
        }
        throw new ArgumentException("network configuration validation failed:\nGet-Config -Config azure did not return a Catzc.Azure.AzureConfig");
    }
}
