// The cross-cutting IP plan (configs/network.yml, [ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)) — the
// single source of truth for vnet / subnet ranges: the per-environment ranges, keyed by azure.yml environment name,
// and the per-subscription hub or spoke networks, keyed by azure.yml subscription name. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.NetworkConfig), so Get-Config -Config network returns this
// typed record. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - the top-level key 'environments' is required and is a non-empty map of well-formed NetworkEnvironment entries;
//   - the top-level key 'subscriptions' is optional and, when present, a non-empty map of well-formed
//     NetworkSubscription entries;
//   - no other top-level key;
//   - no two virtual networks overlap — every environment's and every subscription's vnet_address_space is disjoint from every
//     other ([ADR-AZ-NETWORK#6](/docs/adr/azure/azure-network-model.md#rule-adr-az-network6)).
// The type checks this file alone. The cross-asset sync with azure.yml
// ([ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2),
// [ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5)) joins two configs, so it is the
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

    // The per-subscription hub and spoke networks, keyed by subscription name in file order. Empty when the file has
    // no 'subscriptions' key.
    public IReadOnlyDictionary<string, NetworkSubscription> subscriptions { get; }

    public NetworkConfig(IDictionary d)
    {
        if (d == null || !d.Contains("environments"))
        {
            throw new ArgumentException("network configuration validation failed:\nMissing required top-level key: 'environments'");
        }

        List<string> errors = new List<string>();
        AzureConfig.UnknownKeys(d, new[] { "environments", "subscriptions" }, "network.yml", errors);

        Dictionary<string, NetworkEnvironment> environmentMap = new Dictionary<string, NetworkEnvironment>(StringComparer.Ordinal);
        environments = environmentMap;
        IDictionary rawEnvironments = d["environments"] as IDictionary;
        if (d["environments"] != null && rawEnvironments == null)
        {
            errors.Add("'environments' must be a map of environment name -> { vnet_address_space, default_subnet }");
        }
        else if (rawEnvironments == null || rawEnvironments.Count == 0)
        {
            errors.Add("environments is empty");
        }
        else
        {
            foreach (object k in rawEnvironments.Keys)
            {
                string name = AzureConfig.Text(k);
                environmentMap[name] = new NetworkEnvironment(name, rawEnvironments[k] as IDictionary, errors);
            }
        }

        Dictionary<string, NetworkSubscription> subscriptionMap = new Dictionary<string, NetworkSubscription>(StringComparer.Ordinal);
        subscriptions = subscriptionMap;
        if (d.Contains("subscriptions"))
        {
            IDictionary rawSubscriptions = d["subscriptions"] as IDictionary;
            if (d["subscriptions"] != null && rawSubscriptions == null)
            {
                errors.Add("'subscriptions' must be a map of subscription name -> { kind, vnet_address_space, subnets }");
            }
            else if (rawSubscriptions == null || rawSubscriptions.Count == 0)
            {
                errors.Add("subscriptions is empty");
            }
            else
            {
                foreach (object k in rawSubscriptions.Keys)
                {
                    string name = AzureConfig.Text(k);
                    subscriptionMap[name] = new NetworkSubscription(name, rawSubscriptions[k] as IDictionary, errors);
                }
            }
        }

        CheckVnetOverlap(environmentMap, subscriptionMap, errors);

        if (errors.Count > 0) { throw new ArgumentException("network configuration validation failed:\n" + string.Join("\n", errors)); }
    }

    // No two virtual networks of the plan share an address: environments and subscriptions alike. A range already
    // reported invalid (null) is skipped.
    private static void CheckVnetOverlap(Dictionary<string, NetworkEnvironment> environmentMap,
        Dictionary<string, NetworkSubscription> subscriptionMap, List<string> errors)
    {
        List<KeyValuePair<string, string>> spaces = new List<KeyValuePair<string, string>>();
        foreach (NetworkEnvironment environment in environmentMap.Values)
        {
            if (environment.vnet_address_space != null)
            {
                spaces.Add(new KeyValuePair<string, string>(string.Format("environment '{0}'", environment.name), environment.vnet_address_space));
            }
        }
        foreach (NetworkSubscription subscription in subscriptionMap.Values)
        {
            if (subscription.vnet_address_space != null)
            {
                spaces.Add(new KeyValuePair<string, string>(string.Format("subscription '{0}'", subscription.name), subscription.vnet_address_space));
            }
        }
        for (int i = 0; i < spaces.Count; i++)
        {
            for (int j = 0; j < i; j++)
            {
                if (NetworkCidr.Overlaps(spaces[j].Value, spaces[i].Value))
                {
                    errors.Add(string.Format("network.yml: the vnet of {0} ({1}) overlaps the vnet of {2} ({3})",
                        spaces[i].Key, spaces[i].Value, spaces[j].Key, spaces[j].Value));
                }
            }
        }
    }
}
