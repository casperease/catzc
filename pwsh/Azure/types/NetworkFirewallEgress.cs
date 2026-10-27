using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

// The egress every hub firewall allows from the spoke workload subnets, one rule set for both tiers: service tags in network rules and
// FQDN tags in application rules, so no rule leans on the DNS proxy that only Standard runs. Everything else is denied.
public sealed class NetworkFirewallEgress : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "service_tags", "fqdn_tags", "service_tag_regions" };

    // Declared once: the platform services a workload reaches outbound; storage only in the firewall's own region.
    public static NetworkFirewallEgress Default { get; } = new NetworkFirewallEgress(
        new[] { "AzureMonitor", "AzureActiveDirectory", "Storage.{region}" }, new[] { "WindowsUpdate" },
        new Dictionary<string, string>(StringComparer.Ordinal) { { "westeurope", "WestEurope" }, { "northeurope", "NorthEurope" } });

    // Service tags allowed outbound, in network rules; the firewall policy turns a {region} into its location's tag name.
    public IReadOnlyList<string> service_tags { get; }

    // FQDN tags allowed outbound over HTTPS, in application rules.
    public IReadOnlyList<string> fqdn_tags { get; }

    // The tag name of each Azure region, as the service-tag list spells it (westeurope is WestEurope), so a regional tag is emitted in the
    // documented casing rather than the location's.
    public IReadOnlyDictionary<string, string> service_tag_regions { get; }

    private NetworkFirewallEgress(string[] serviceTags, string[] fqdnTags, Dictionary<string, string> serviceTagRegions)
    {
        service_tags = serviceTags;
        fqdn_tags = fqdnTags;
        service_tag_regions = serviceTagRegions;
    }

    // Reads firewall_egress; a key the file omits takes the default, and every violation is appended to errors.
    internal NetworkFirewallEgress(IDictionary d, List<string> errors)
    {
        service_tags = Default.service_tags;
        fqdn_tags = Default.fqdn_tags;
        service_tag_regions = Default.service_tag_regions;
        if (d == null)
        {
            errors.Add("firewall_egress must be a mapping of service_tags, fqdn_tags and service_tag_regions");
            return;
        }
        AzureConfig.UnknownKeys(d, AllowedKeys, "firewall_egress", errors);
        if (d.Contains("service_tags")) { service_tags = Tags("service_tags", d["service_tags"], errors) ?? service_tags; }
        if (d.Contains("fqdn_tags")) { fqdn_tags = Tags("fqdn_tags", d["fqdn_tags"], errors) ?? fqdn_tags; }
        if (d.Contains("service_tag_regions")) { service_tag_regions = Regions(d["service_tag_regions"], errors) ?? service_tag_regions; }
    }

    // A file's map replaces the default whole: a lowercase Azure location to its tag name, letters and digits only.
    private static Dictionary<string, string> Regions(object raw, List<string> errors)
    {
        IDictionary map = raw as IDictionary;
        if (map == null || map.Count == 0)
        {
            errors.Add("firewall_egress.service_tag_regions must be a map of Azure location to its service-tag region name");
            return null;
        }
        var regions = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (DictionaryEntry entry in map)
        {
            string location = entry.Key == null ? string.Empty : entry.Key.ToString();
            string name = entry.Value == null ? string.Empty : entry.Value.ToString();
            if (!Regex.IsMatch(location, "^[a-z0-9]+$") || !Regex.IsMatch(name, "^[A-Za-z0-9]+$")
                || !string.Equals(location, name, StringComparison.OrdinalIgnoreCase))
            {
                errors.Add(string.Format("firewall_egress.service_tag_regions: '{0}: {1}' must map a lowercase location to the same name as the service tag spells it", location, name));
                continue;
            }
            regions[location] = name;
        }
        return regions;
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
