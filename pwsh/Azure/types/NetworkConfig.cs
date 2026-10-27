using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

// The IP plan of network.yml: per-environment ranges and per-subscription hub or spoke networks.
public sealed class NetworkConfig : Catzc.Base.Objects.DictionaryRecord
{
    // In file order: the dictionary is never mutated after construction.
    public IReadOnlyDictionary<string, NetworkEnvironment> environments { get; }

    // Empty when the file has no subscriptions key.
    public IReadOnlyDictionary<string, NetworkSubscription> subscriptions { get; }

    // The subnets Azure does not let a network security group attach to (its gateway, firewall and route-server subnets); every other
    // subnet carries one. Declared once here; network.yml may override the list.
    public static IReadOnlyList<string> DefaultNoNsgSubnets { get; } = new[] { "GatewaySubnet", "AzureFirewallSubnet", "AzureFirewallManagementSubnet", "RouteServerSubnet" };

    public IReadOnlyList<string> no_nsg_subnets { get; }

    // The egress every hub firewall allows; the default is declared once on NetworkFirewallEgress.
    public NetworkFirewallEgress firewall_egress { get; }

    // The inbound flows the security groups allow, by subnet role; the default is declared once on NetworkFlow.
    public IReadOnlyList<NetworkFlow> nsg_flows { get; }

    public NetworkConfig(IDictionary d)
    {
        if (d == null || !d.Contains("environments"))
        {
            throw new ArgumentException("network configuration validation failed:\nMissing required top-level key: 'environments'");
        }

        List<string> errors = new List<string>();
        AzureConfig.UnknownKeys(d, new[] { "environments", "subscriptions", "no_nsg_subnets", "firewall_egress", "nsg_flows" }, "network.yml", errors);
        nsg_flows = NetworkFlow.Default;
        if (d.Contains("nsg_flows"))
        {
            var flows = new List<NetworkFlow>();
            object raw = d["nsg_flows"];
            if (raw is IEnumerable list && !(raw is string) && !(raw is IDictionary))
            {
                int index = 0;
                foreach (object item in list)
                {
                    NetworkFlow flow = NetworkFlow.Read(index++, item, errors);
                    if (flow != null) { flows.Add(flow); }
                }
            }
            else { errors.Add("nsg_flows must be a list of { name, to, from, ports, protocol } entries"); }
            nsg_flows = flows.ToArray();
        }
        firewall_egress = d.Contains("firewall_egress") ? new NetworkFirewallEgress(d["firewall_egress"] as IDictionary, errors) : NetworkFirewallEgress.Default;
        no_nsg_subnets = DefaultNoNsgSubnets;
        if (d.Contains("no_nsg_subnets"))
        {
            var names = new List<string>();
            object raw = d["no_nsg_subnets"];
            if (raw is IEnumerable list && !(raw is string) && !(raw is IDictionary))
            {
                foreach (object item in list) { names.Add(item == null ? string.Empty : item.ToString()); }
            }
            if (names.Count == 0 || names.Exists(string.IsNullOrWhiteSpace)) { errors.Add("no_nsg_subnets must be a non-empty list of subnet names"); }
            else { no_nsg_subnets = names.ToArray(); }
        }

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

    // No two virtual networks share an address; a range already reported invalid is skipped.
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
