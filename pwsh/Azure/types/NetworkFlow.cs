using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

// One inbound flow a subnet's security group allows; every other inbound flow from the network is denied. Subnets are named by role, so a
// flow holds for every subnet of that role in every network.
public sealed class NetworkFlow : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "name", "to", "from", "ports", "protocol" };

    // The roles a flow reaches: a spoke's private-endpoints subnet, a spoke's workload subnets, a hub's shared-services subnet.
    public static readonly string[] Destinations = { "private-endpoints", "workload", "shared-services" };

    // Where a flow comes from: the destination subnet itself, the spoke's workload subnets, or the hub's shared-services subnet.
    public static readonly string[] Sources = { "same-subnet", "workload", "shared-services" };

    private static readonly string[] Protocols = { "Tcp", "Udp", "*" };

    // Declared once: the flows the landing zone needs, and no other.
    public static IReadOnlyList<NetworkFlow> Default { get; } = new[]
    {
        new NetworkFlow("workload-to-private-endpoints", "private-endpoints", "workload", new[] { "443", "1433" }, "Tcp"),
        new NetworkFlow("shared-services-management", "workload", "shared-services", new[] { "22", "3389" }, "Tcp"),
        new NetworkFlow("same-subnet", "workload", "same-subnet", new[] { "*" }, "*"),
    };

    // The security rule's name, lowercase with hyphens.
    public string name { get; }

    // The destination role (Destinations).
    public string to { get; }

    // The source (Sources).
    public string from { get; }

    // Destination ports or ranges; "*" for any.
    public IReadOnlyList<string> ports { get; }

    // Tcp, Udp or "*".
    public string protocol { get; }

    private NetworkFlow(string name, string to, string from, string[] ports, string protocol)
    {
        this.name = name;
        this.to = to;
        this.from = from;
        this.ports = ports;
        this.protocol = protocol;
    }

    // Reads one entry of nsg_flows, appending every violation to errors; null when the entry is not a mapping.
    internal static NetworkFlow Read(int index, object raw, List<string> errors)
    {
        string where = string.Format("nsg_flows[{0}]", index);
        IDictionary d = raw as IDictionary;
        if (d == null)
        {
            errors.Add(where + " must be a mapping of name, to, from, ports and protocol");
            return null;
        }
        AzureConfig.UnknownKeys(d, AllowedKeys, where, errors);
        string name = d.Contains("name") ? AzureConfig.Text(d["name"]) : null;
        string to = d.Contains("to") ? AzureConfig.Text(d["to"]) : null;
        string from = d.Contains("from") ? AzureConfig.Text(d["from"]) : null;
        string protocol = d.Contains("protocol") ? AzureConfig.Text(d["protocol"]) : null;
        int before = errors.Count;
        if (name == null || !Regex.IsMatch(name, "^[a-z][a-z0-9-]{0,78}[a-z0-9]$")) { errors.Add(string.Format("{0} has invalid name '{1}' (lowercase letters, digits and hyphens)", where, name)); }
        if (Array.IndexOf(Destinations, to) < 0) { errors.Add(string.Format("{0} has invalid to '{1}' (must be one of {2})", where, to, string.Join(", ", Destinations))); }
        if (Array.IndexOf(Sources, from) < 0) { errors.Add(string.Format("{0} has invalid from '{1}' (must be one of {2})", where, from, string.Join(", ", Sources))); }
        if (Array.IndexOf(Protocols, protocol) < 0) { errors.Add(string.Format("{0} has invalid protocol '{1}' (must be one of {2})", where, protocol, string.Join(", ", Protocols))); }
        var ports = new List<string>();
        if (d.Contains("ports") && d["ports"] is IEnumerable list && !(d["ports"] is string) && !(d["ports"] is IDictionary))
        {
            foreach (object item in list) { ports.Add(AzureConfig.Text(item)); }
        }
        if (ports.Count == 0 || ports.Exists(port => !Regex.IsMatch(port ?? string.Empty, @"^(\*|\d{1,5}(-\d{1,5})?)$")))
        {
            errors.Add(where + " must list its ports, each a number, a range like 8000-8080, or *");
        }
        return errors.Count > before ? null : new NetworkFlow(name, to, from, ports.ToArray(), protocol);
    }
}
