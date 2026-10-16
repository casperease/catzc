/*
---
catzc:
  derived:
    path: automation/Catzc.Azure/types/NetworkSubscription.cs
    folder: types
    name: network-subscription
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure/types/NetworkSubscription.cs.md
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-AZ-NETWORK
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class NetworkSubscription : Catzc.Base.Objects.DictionaryRecord
{
    // The kind of a non-customer (shared) subscription's network.
    public const string Hub = "hub";

    // The kind of a customer subscription's network.
    public const string Spoke = "spoke";

    // The spoke subnet that holds the private endpoints of the workloads in the spoke.
    public const string PrivateEndpointsSubnet = "private-endpoints";

    private static readonly string[] AllowedKeys = { "kind", "vnet_address_space", "subnets" };

    private static readonly string[] HubSubnetNames = { "GatewaySubnet", "AzureFirewallSubnet", "shared-services" };

    public static IReadOnlyList<string> HubSubnets => HubSubnetNames;

    // The subscription name (the map key; an azure.yml subscription).
    public string name { get; }

    // `hub` or `spoke`. Null when missing or invalid.
    public string kind { get; }

    // The VNet address space (IPv4 CIDR, e.g. 10.100.0.0/16). Null when missing or invalid.
    public string vnet_address_space { get; }

    // The subnets, subnet name -> IPv4 CIDR, in file order. Empty when missing or invalid; an invalid range is left out.
    public IReadOnlyDictionary<string, string> subnets { get; }

    // Builds the record and throws one ArgumentException listing every violation.
    public NetworkSubscription(string name, IDictionary d) : this(name, d, null) { }

    // Builds the record best-effort, appending every violation to `errors` (throws only when `errors` is null).
    internal NetworkSubscription(string name, IDictionary d, List<string> errors)
    {
        List<string> own = errors ?? new List<string>();
        int before = own.Count;
        string where = string.Format("network subscription '{0}'", name);
        this.name = name;
        Dictionary<string, string> map = new Dictionary<string, string>(StringComparer.Ordinal);
        subnets = map;

        if (name == null || !Regex.IsMatch(name, AzureConfig.IdentifierPattern))
        {
            own.Add(string.Format("{0} is not a valid identifier (must match {1})", where, AzureConfig.IdentifierPattern));
        }
        if (d == null)
        {
            own.Add(string.Format("{0} must be a mapping with kind, vnet_address_space and subnets", where));
        }
        else
        {
            AzureConfig.UnknownKeys(d, AllowedKeys, where, own);
            kind = Kind(where, d, own);
            vnet_address_space = Vnet(where, d, own);
            ReadSubnets(where, d, map, own);
            CheckSubnetRanges(where, vnet_address_space, map, own);
            List<string> names = SubnetNames(d);
            if (kind == Hub) { CheckHub(where, names, own); }
            if (kind == Spoke) { CheckSpoke(where, names, own); }
        }

        if (errors == null && own.Count > before) { throw new ArgumentException(string.Join("\n", own)); }
    }

    private static string Kind(string where, IDictionary d, List<string> errors)
    {
        if (!d.Contains("kind"))
        {
            errors.Add(string.Format("{0} is missing 'kind' (hub or spoke)", where));
            return null;
        }
        string value = AzureConfig.Text(d["kind"]);
        if (value == Hub || value == Spoke) { return value; }
        errors.Add(string.Format("{0} has invalid kind '{1}' (must be hub or spoke)", where, value));
        return null;
    }

    private static string Vnet(string where, IDictionary d, List<string> errors)
    {
        if (!d.Contains("vnet_address_space"))
        {
            errors.Add(string.Format("{0} is missing 'vnet_address_space'", where));
            return null;
        }
        string value = AzureConfig.Text(d["vnet_address_space"]);
        if (NetworkCidr.IsValid(value)) { return value; }
        errors.Add(string.Format("{0} has invalid vnet_address_space '{1}' (must be an aligned IPv4 CIDR, e.g. 10.100.0.0/16)", where, value));
        return null;
    }

    // Reads the subnets map; a subnet with an invalid range is reported and left out of the map.
    private static void ReadSubnets(string where, IDictionary d, Dictionary<string, string> map, List<string> errors)
    {
        IDictionary raw = d.Contains("subnets") ? d["subnets"] as IDictionary : null;
        if (!d.Contains("subnets"))
        {
            errors.Add(string.Format("{0} is missing 'subnets'", where));
            return;
        }
        if (d["subnets"] != null && raw == null)
        {
            errors.Add(string.Format("{0} 'subnets' must be a map of subnet name -> IPv4 CIDR", where));
            return;
        }
        if (raw == null || raw.Count == 0)
        {
            errors.Add(string.Format("{0} subnets is empty", where));
            return;
        }
        foreach (object k in raw.Keys)
        {
            string subnet = AzureConfig.Text(k);
            string value = AzureConfig.Text(raw[k]);
            if (NetworkCidr.IsValid(value)) { map[subnet] = value; }
            else
            {
                errors.Add(string.Format("{0} subnet '{1}' has invalid range '{2}' (must be an aligned IPv4 CIDR, e.g. 10.100.1.0/24)", where, subnet, value));
            }
        }
    }

    // Every subnet lies inside the VNet, and no two subnets of the VNet overlap.
    private static void CheckSubnetRanges(string where, string vnet, Dictionary<string, string> map, List<string> errors)
    {
        List<KeyValuePair<string, string>> seen = new List<KeyValuePair<string, string>>();
        foreach (KeyValuePair<string, string> subnet in map)
        {
            if (vnet != null && !NetworkCidr.Contains(vnet, subnet.Value))
            {
                errors.Add(string.Format("{0} subnet '{1}' ({2}) is not inside its vnet_address_space '{3}'", where, subnet.Key, subnet.Value, vnet));
            }
            foreach (KeyValuePair<string, string> other in seen)
            {
                if (NetworkCidr.Overlaps(other.Value, subnet.Value))
                {
                    errors.Add(string.Format("{0} subnet '{1}' ({2}) overlaps subnet '{3}' ({4})", where, subnet.Key, subnet.Value, other.Key, other.Value));
                }
            }
            seen.Add(subnet);
        }
    }

    private static List<string> SubnetNames(IDictionary d)
    {
        List<string> names = new List<string>();
        IDictionary raw = d.Contains("subnets") ? d["subnets"] as IDictionary : null;
        if (raw == null) { return names; }
        foreach (object k in raw.Keys) { names.Add(AzureConfig.Text(k)); }
        return names;
    }

    // A hub carries exactly the hub subnets. Skipped when subnets is missing or empty (reported already).
    private static void CheckHub(string where, List<string> names, List<string> errors)
    {
        if (names.Count == 0) { return; }
        foreach (string required in HubSubnetNames)
        {
            if (!names.Contains(required))
            {
                errors.Add(string.Format("{0} is a hub without subnet '{1}' (a hub carries exactly: {2})", where, required, string.Join(", ", HubSubnetNames)));
            }
        }
        foreach (string subnet in names)
        {
            if (Array.IndexOf(HubSubnetNames, subnet) < 0)
            {
                errors.Add(string.Format("{0} is a hub with subnet '{1}' (a hub carries exactly: {2})", where, subnet, string.Join(", ", HubSubnetNames)));
            }
        }
    }

    private static void CheckSpoke(string where, List<string> names, List<string> errors)
    {
        if (names.Count == 0) { return; }
        if (!names.Contains(PrivateEndpointsSubnet))
        {
            errors.Add(string.Format("{0} is a spoke without subnet '{1}'", where, PrivateEndpointsSubnet));
        }
        foreach (string subnet in names)
        {
            if (subnet != PrivateEndpointsSubnet && !Regex.IsMatch(subnet, AzureConfig.IdentifierPattern))
            {
                errors.Add(string.Format("{0} is a spoke with workload subnet '{1}', which is not an environment name (must match {2})",
                    where, subnet, AzureConfig.IdentifierPattern));
            }
        }
    }
}
