// The rules Test-BicepTemplateCompliance holds every compiled template to; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Azure.Templates;

public sealed class TemplateComplianceConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "template-compliance configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "untaggable_types", "diagnostic_types", "public_access_properties", "tls_properties", "zone_properties", "property_rules", "known_findings" };
    private static readonly string[] RuleKeys = { "type", "path", "equals", "absent", "reason" };

    // The resource types Azure gives no top-level tags property; every other deployed resource must carry the CAF tags.
    public IReadOnlyList<string> untaggable_types { get; } = new[]
    {
        "Microsoft.Authorization/locks",                                        // an extension resource; ARM has no tags on it
        "Microsoft.Authorization/policyAssignments",                            // policy objects carry metadata, not tags
        "Microsoft.Authorization/policyDefinitions",                            // policy objects carry metadata, not tags
        "Microsoft.Authorization/roleAssignments",                              // an extension resource; ARM has no tags on it
        "Microsoft.Consumption/budgets",                                        // a budget's schema has no tags
        "Microsoft.Insights/diagnosticSettings",                                // an extension resource; ARM has no tags on it
        "Microsoft.Network/firewallPolicies/ruleCollectionGroups",               // a child: tagged through its firewall policy
        "Microsoft.Network/privateEndpoints/privateDnsZoneGroups",              // a child: tagged through its private endpoint
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",             // a child: tagged through its virtual network
        "Microsoft.OperationalInsights/queryPacks/queries",                     // a child: its tags sit in properties, not at the top
        "Microsoft.Resources/deployments",                                      // a nested deployment; the evaluator checks its resources
        "Microsoft.Sql/servers/auditingSettings",                               // a child: tagged through its server
        "Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies",     // a child: tagged through its database
        "Microsoft.Storage/storageAccounts/blobServices",                       // a child: tagged through its storage account
        "Microsoft.Storage/storageAccounts/managementPolicies",                 // a child: tagged through its storage account
    };

    // The resource kinds that must each have a diagnostic setting scoped to them wherever one is deployed.
    public IReadOnlyList<string> diagnostic_types { get; } = new[]
    {
        "Microsoft.Storage/storageAccounts",
        "Microsoft.Storage/storageAccounts/blobServices",
        "Microsoft.Sql/servers/databases",
        "Microsoft.KeyVault/vaults",
        "Microsoft.Network/networkSecurityGroups",
        "Microsoft.Network/virtualNetworks",
        "Microsoft.Network/azureFirewalls",
        "Microsoft.DataFactory/factories",
    };

    // The properties that turn public network access on; a resource whose value resolves to Enabled fails.
    public IReadOnlyList<string> public_access_properties { get; } = new[] { "publicNetworkAccess" };

    // The TLS-minimum property names and the values each accepts (1.2 and above).
    public IReadOnlyDictionary<string, IReadOnlyList<string>> tls_properties { get; } = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal)
    {
        { "minimumTlsVersion", new[] { "TLS1_2", "TLS1_3" } },
        { "minimalTlsVersion", new[] { "1.2", "1.3" } },
    };

    // The zone-redundancy properties a production slot must resolve to true.
    public IReadOnlyList<string> zone_properties { get; } = new[] { "zoneRedundant" };

    // The declared property rules: on every deployed resource of the type, the value at the path must resolve to equals, or be absent.
    public IReadOnlyList<CompliancePropertyRule> property_rules { get; } = new[]
    {
        new CompliancePropertyRule("Microsoft.Network/virtualNetworks", "properties.subnets[*].properties.defaultOutboundAccess", false, false,
            "no subnet gets an implicit outbound address; egress leaves through a route"),
        new CompliancePropertyRule("Microsoft.Network/networkInterfaces", "properties.ipConfigurations[*].properties.publicIPAddress", null, true,
            "a VM's network interface takes no public IP; it is reached through the network"),
    };

    public IReadOnlyDictionary<string, string> known_findings { get; } = new Dictionary<string, string>(StringComparer.Ordinal);

    public TemplateComplianceConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("untaggable_types")) { untaggable_types = Words("untaggable_types", raw["untaggable_types"], errors) ?? untaggable_types; }
        if (raw.Contains("diagnostic_types")) { diagnostic_types = Words("diagnostic_types", raw["diagnostic_types"], errors) ?? diagnostic_types; }
        if (raw.Contains("public_access_properties")) { public_access_properties = Words("public_access_properties", raw["public_access_properties"], errors) ?? public_access_properties; }
        if (raw.Contains("zone_properties")) { zone_properties = Words("zone_properties", raw["zone_properties"], errors) ?? zone_properties; }
        if (raw.Contains("tls_properties"))
        {
            IDictionary map = raw["tls_properties"] as IDictionary;
            if (map == null || map.Count == 0) { errors.Add("tls_properties must be a non-empty mapping of property name to its accepted values"); }
            else
            {
                var tls = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal);
                foreach (object k in map.Keys)
                {
                    string name = k == null ? string.Empty : k.ToString();
                    IReadOnlyList<string> accepted = Words("tls_properties['" + name + "']", map[k], errors);
                    if (accepted != null) { tls[name] = accepted; }
                }
                tls_properties = tls;
            }
        }
        if (raw.Contains("property_rules")) { property_rules = PropertyRules(raw["property_rules"], errors) ?? property_rules; }
        if (raw.Contains("known_findings") && raw["known_findings"] != null)
        {
            IEnumerable entries = raw["known_findings"] as IEnumerable;
            if (entries == null || raw["known_findings"] is string || raw["known_findings"] is IDictionary) { errors.Add("known_findings must be a list of { finding, step } entries"); }
            else
            {
                var known = new Dictionary<string, string>(StringComparer.Ordinal);
                int index = 0;
                foreach (object item in entries)
                {
                    IDictionary entry = item as IDictionary;
                    string finding = entry != null && entry.Contains("finding") && entry["finding"] != null ? entry["finding"].ToString() : null;
                    string step = entry != null && entry.Contains("step") && entry["step"] != null ? entry["step"].ToString() : null;
                    if (string.IsNullOrWhiteSpace(finding) || string.IsNullOrWhiteSpace(step) || entry.Count != 2)
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "known_findings[{0}] must hold exactly a finding and the step that closes it", index));
                    }
                    else if (known.ContainsKey(finding))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "known_findings[{0}]: duplicate finding '{1}'", index, finding));
                    }
                    else { known[finding] = step; }
                    index++;
                }
                known_findings = known;
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    public bool IsTaggable(string type) { return !Contains(untaggable_types, type); }

    public bool NeedsDiagnostics(string type) { return Contains(diagnostic_types, type); }

    static bool Contains(IReadOnlyList<string> list, string value)
    {
        foreach (string item in list)
        {
            if (string.Equals(item, value, StringComparison.OrdinalIgnoreCase)) { return true; }
        }
        return false;
    }

    static IReadOnlyList<CompliancePropertyRule> PropertyRules(object value, List<string> errors)
    {
        IEnumerable entries = value as IEnumerable;
        if (value == null || value is string || value is IDictionary || entries == null)
        {
            errors.Add("property_rules must be a list of { type, path, equals | absent, reason } entries");
            return null;
        }
        var rules = new List<CompliancePropertyRule>();
        int index = 0;
        foreach (object item in entries)
        {
            IDictionary entry = item as IDictionary;
            string at = string.Format(CultureInfo.InvariantCulture, "property_rules[{0}]", index++);
            if (entry == null) { errors.Add(at + " must be a mapping"); continue; }
            foreach (object k in entry.Keys)
            {
                if (Array.IndexOf(RuleKeys, k == null ? null : k.ToString()) < 0) { errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", at, k, string.Join(", ", RuleKeys))); }
            }
            string type = entry.Contains("type") && entry["type"] != null ? entry["type"].ToString() : null;
            string path = entry.Contains("path") && entry["path"] != null ? entry["path"].ToString() : null;
            string reason = entry.Contains("reason") && entry["reason"] != null ? entry["reason"].ToString() : null;
            bool absent = entry.Contains("absent") && entry["absent"] is bool flag && flag;
            if (string.IsNullOrWhiteSpace(type) || string.IsNullOrWhiteSpace(path) || string.IsNullOrWhiteSpace(reason))
            {
                errors.Add(at + " must name a type, a path and a reason");
                continue;
            }
            if (absent == entry.Contains("equals"))
            {
                errors.Add(at + " must hold exactly one of equals and absent: true");
                continue;
            }
            rules.Add(new CompliancePropertyRule(type, path, absent ? null : entry["equals"], absent, reason));
        }
        return rules.ToArray();
    }

    static IReadOnlyList<string> Words(string name, object value, List<string> errors)
    {
        List<string> items = new List<string>();
        if (value is string single) { items.Add(single); }
        else if (value is IEnumerable list && !(value is IDictionary))
        {
            foreach (object item in list) { items.Add(item == null ? string.Empty : item.ToString()); }
        }
        else
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a non-empty list of strings", name));
            return null;
        }
        if (items.Count == 0 || items.Exists(string.IsNullOrWhiteSpace))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a non-empty list of strings", name));
            return null;
        }
        return items.ToArray();
    }
}
