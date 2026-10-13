// One environment's IP plan in configs/network.yml ([ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)): the
// vnet address space and default subnet, keyed by the azure.yml environment name. Mirrors an `environments` entry
// (snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
// NetworkConfig builds one per entry and collects its violations with the file's.
//
// Shape: the name is a lower-snake_case identifier; vnet_address_space and default_subnet are required IPv4 CIDRs
// (a.b.c.d/n, 0 <= n <= 32); no other key.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class NetworkEnvironment : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "vnet_address_space", "default_subnet" };

    // The environment name (the map key; an azure.yml environment).
    public string name { get; }

    // The environment's vnet address space (IPv4 CIDR, e.g. 10.10.0.0/16). Null when missing or invalid.
    public string vnet_address_space { get; }

    // The environment's default subnet (IPv4 CIDR, e.g. 10.10.0.0/24). Null when missing or invalid.
    public string default_subnet { get; }

    // Builds the record and throws one ArgumentException listing every violation.
    public NetworkEnvironment(string name, IDictionary d) : this(name, d, null) { }

    // Builds the record best-effort, appending every violation to `errors` (throws only when `errors` is null).
    internal NetworkEnvironment(string name, IDictionary d, List<string> errors)
    {
        List<string> own = errors ?? new List<string>();
        int before = own.Count;
        this.name = name;

        if (name == null || !Regex.IsMatch(name, AzureConfig.IdentifierPattern))
        {
            own.Add(string.Format("network environment '{0}' is not a valid identifier (must match {1})", name, AzureConfig.IdentifierPattern));
        }
        if (d == null)
        {
            own.Add(string.Format("network environment '{0}' must be a mapping with vnet_address_space and default_subnet", name));
        }
        else
        {
            AzureConfig.UnknownKeys(d, AllowedKeys, string.Format("network environment '{0}'", name), own);
            vnet_address_space = Cidr(name, d, "vnet_address_space", own);
            default_subnet = Cidr(name, d, "default_subnet", own);
        }

        if (errors == null && own.Count > before) { throw new ArgumentException(string.Join("\n", own)); }
    }

    private static string Cidr(string name, IDictionary d, string key, List<string> errors)
    {
        if (!d.Contains(key))
        {
            errors.Add(string.Format("network environment '{0}' is missing '{1}'", name, key));
            return null;
        }
        string value = AzureConfig.Text(d[key]);
        if (IsIPv4Cidr(value)) { return value; }
        errors.Add(string.Format("network environment '{0}' has invalid {1} '{2}' (must be IPv4 CIDR, e.g. 10.10.0.0/16)", name, key, value));
        return null;
    }

    // A valid IPv4 address followed by a 0-32 prefix length.
    private static bool IsIPv4Cidr(string value)
    {
        string[] parts = value.Split('/');
        if (parts.Length != 2) { return false; }
        IPAddress ip;
        if (!IPAddress.TryParse(parts[0], out ip) || ip.AddressFamily != AddressFamily.InterNetwork) { return false; }
        int prefix;
        return int.TryParse(parts[1], out prefix) && prefix >= 0 && prefix <= 32;
    }
}
