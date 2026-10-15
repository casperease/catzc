/*
---
catzc:
  derived:
    path: automation/Catzc.Azure/types/NetworkEnvironment.cs
    kind: csharp-type
    module: Catzc.Azure
    relatives:
      page: docs/references/automation/catzc-azure/types/NetworkEnvironment.cs.md
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
            if (vnet_address_space != null && default_subnet != null && !NetworkCidr.Contains(vnet_address_space, default_subnet))
            {
                own.Add(string.Format("network environment '{0}' default_subnet '{1}' is not inside its vnet_address_space '{2}'",
                    name, default_subnet, vnet_address_space));
            }
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
        if (NetworkCidr.IsValid(value)) { return value; }
        errors.Add(string.Format("network environment '{0}' has invalid {1} '{2}' (must be an aligned IPv4 CIDR, e.g. 10.10.0.0/16)", name, key, value));
        return null;
    }
}
