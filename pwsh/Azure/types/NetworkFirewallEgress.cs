using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

// The egress every hub firewall allows from the spoke workload subnets, one rule set for both tiers: service tags in network rules and
// FQDN tags in application rules, so no rule leans on the DNS proxy that only Standard runs. Everything else is denied.
public sealed class NetworkFirewallEgress : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "service_tags", "fqdn_tags" };

    // Declared once: the platform services a workload reaches outbound.
    public static NetworkFirewallEgress Default { get; } = new NetworkFirewallEgress(
        new[] { "AzureMonitor", "AzureActiveDirectory", "Storage" }, new[] { "WindowsUpdate" });

    // Service tags allowed outbound, in network rules.
    public IReadOnlyList<string> service_tags { get; }

    // FQDN tags allowed outbound over HTTPS, in application rules.
    public IReadOnlyList<string> fqdn_tags { get; }

    private NetworkFirewallEgress(string[] serviceTags, string[] fqdnTags)
    {
        service_tags = serviceTags;
        fqdn_tags = fqdnTags;
    }

    // Reads firewall_egress; a key the file omits takes the default, and every violation is appended to errors.
    internal NetworkFirewallEgress(IDictionary d, List<string> errors)
    {
        service_tags = Default.service_tags;
        fqdn_tags = Default.fqdn_tags;
        if (d == null)
        {
            errors.Add("firewall_egress must be a mapping of service_tags and fqdn_tags");
            return;
        }
        AzureConfig.UnknownKeys(d, AllowedKeys, "firewall_egress", errors);
        if (d.Contains("service_tags")) { service_tags = Tags("service_tags", d["service_tags"], errors) ?? service_tags; }
        if (d.Contains("fqdn_tags")) { fqdn_tags = Tags("fqdn_tags", d["fqdn_tags"], errors) ?? fqdn_tags; }
    }

    // An empty list is allowed: it opens nothing.
    private static string[] Tags(string key, object raw, List<string> errors)
    {
        var tags = new List<string>();
        if (raw is IEnumerable list && !(raw is string) && !(raw is IDictionary))
        {
            foreach (object item in list) { tags.Add(item == null ? string.Empty : item.ToString()); }
            if (!tags.Exists(string.IsNullOrWhiteSpace)) { return tags.ToArray(); }
        }
        errors.Add(string.Format("firewall_egress.{0} must be a list of tag names", key));
        return null;
    }
}
