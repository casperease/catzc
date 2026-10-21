/*
---
catzc:
  immutable:
    with_body_sha: "08088962be8e"
  edges:
    test: pwsh/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
    docs: "[NetworkConfig.cs.md](../../../docs/references/pwsh/catzc-azure/types/NetworkConfig.cs.md)"
    cites:
      - ADR-AZ-NETWORK
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

public sealed class NetworkConfig : Catzc.Base.Objects.DictionaryRecord
{
    public IReadOnlyDictionary<string, NetworkEnvironment> environments { get; }

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
