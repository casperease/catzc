// The Azure identity layer (configs/azure.yml, ): the org, the minimum Bicep CLI version, and the tenants, environments and...
// [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6),
// [ADR-AZ-DATAMOD#11](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11),
// [ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6),
// [ADR-AZ-DATAMOD#8](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod8),
// [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3),
// [ADR-AZ-DATAMOD#7](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod7)
// [comment:1](/docs/references/automation/catzc-azure/types/AzureConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class AzureConfig : Catzc.Base.Objects.DictionaryRecord
{
    // A tenant or subscription name: a lower-snake_case identifier.
    internal const string IdentifierPattern = "^[a-z][a-z0-9_]*$";

    private static readonly string[] RequiredKeys = { "org", "bicep_min_version", "tenants", "subscriptions", "environments" };

    private static readonly string[] AllowedKeys = { "org", "bicep_min_version", "tenants", "subscriptions", "environments", "policy_enforcement" };

    // The keys of policy_enforcement: the production environments and every other environment.
    private static readonly string[] PolicyEnforcementKeys = { "production", "nonproduction" };

    // The policy enforcement modes, spelled as the Azure policy assignment's enforcementMode takes them.
    private static readonly string[] PolicyEnforcementModes = { "Default", "DoNotEnforce" };

    // The sensible default of policy_enforcement, declared once: production enforces its policies, every other environment audits them...
    // [comment:2](/docs/references/automation/catzc-azure/types/AzureConfig.cs.md#comment2)
    public static IReadOnlyDictionary<string, string> DefaultPolicyEnforcement { get; } = new ReadOnlyDictionary<string, string>(
        new Dictionary<string, string>(StringComparer.Ordinal) { { "production", "Default" }, { "nonproduction", "DoNotEnforce" } });

    // The vertical/organization shortcode — the <org> component of every resource name.
    public string org { get; }

    // The minimum Bicep CLI version (MAJOR.MINOR.PATCH).
    public string bicep_min_version { get; }

    // The Entra tenants, keyed by name.
    public IReadOnlyDictionary<string, AzureTenantRecord> tenants { get; }

    // The subscriptions, keyed by name.
    public IReadOnlyDictionary<string, AzureSubscriptionRecord> subscriptions { get; }

    // The environments, keyed by readable name.
    public IReadOnlyDictionary<string, AzureEnvironmentRecord> environments { get; }

    // The policy enforcement mode per environment class (production, nonproduction), always complete: the keys the file omits take...
    // [comment:3](/docs/references/automation/catzc-azure/types/AzureConfig.cs.md#comment3)
    public IReadOnlyDictionary<string, string> policy_enforcement { get; }

    public AzureConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        foreach (string key in RequiredKeys)
        {
            if (d == null || !d.Contains(key)) { errors.Add(string.Format("Missing required top-level key: '{0}'", key)); }
        }
        if (errors.Count > 0) { Fail(errors); }

        UnknownKeys(d, AllowedKeys, "azure.yml", errors);

        string orgValue = Text(d["org"]);
        if (Regex.IsMatch(orgValue, "^[a-z][a-z0-9]{1,2}$")) { org = orgValue; }
        else { errors.Add(string.Format("org '{0}' is invalid (must be 2-3 lowercase alphanumeric chars starting with a letter)", orgValue)); }

        string bicep = Text(d["bicep_min_version"]);
        if (Regex.IsMatch(bicep, "^[0-9]+\\.[0-9]+\\.[0-9]+$")) { bicep_min_version = bicep; }
        else { errors.Add(string.Format("bicep_min_version '{0}' is invalid (must be MAJOR.MINOR.PATCH, e.g. 0.30.0)", bicep)); }

        Dictionary<string, AzureTenantRecord> tenantMap = new Dictionary<string, AzureTenantRecord>(StringComparer.Ordinal);
        foreach (KeyValuePair<string, IDictionary> entry in Entries(d["tenants"], "tenants", errors))
        {
            tenantMap[entry.Key] = new AzureTenantRecord(entry.Key, entry.Value, errors);
        }
        tenants = tenantMap;

        Dictionary<string, AzureEnvironmentRecord> environmentMap = new Dictionary<string, AzureEnvironmentRecord>(StringComparer.Ordinal);
        foreach (KeyValuePair<string, IDictionary> entry in Entries(d["environments"], "environments", errors))
        {
            environmentMap[entry.Key] = new AzureEnvironmentRecord(entry.Key, entry.Value, errors);
        }
        environments = environmentMap;

        Dictionary<string, AzureSubscriptionRecord> subscriptionMap = new Dictionary<string, AzureSubscriptionRecord>(StringComparer.Ordinal);
        foreach (KeyValuePair<string, IDictionary> entry in Entries(d["subscriptions"], "subscriptions", errors))
        {
            subscriptionMap[entry.Key] = new AzureSubscriptionRecord(entry.Key, entry.Value, errors);
        }
        subscriptions = subscriptionMap;

        policy_enforcement = PolicyEnforcement(d, errors);

        CheckShortcodes(errors);
        CheckReferences(errors);
        CheckCustomerDisjointness(errors);

        if (errors.Count > 0) { Fail(errors); }
    }

    private static void Fail(List<string> errors)
    {
        throw new ArgumentException("azure configuration validation failed:\n" + string.Join("\n", errors));
    }

    // The optional policy_enforcement map, completed from DefaultPolicyEnforcement: an omitted map is the default, and a partial map...
    // [comment:4](/docs/references/automation/catzc-azure/types/AzureConfig.cs.md#comment4)
    private static IReadOnlyDictionary<string, string> PolicyEnforcement(IDictionary d, List<string> errors)
    {
        Dictionary<string, string> modes = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (KeyValuePair<string, string> entry in DefaultPolicyEnforcement) { modes[entry.Key] = entry.Value; }
        if (!d.Contains("policy_enforcement")) { return new ReadOnlyDictionary<string, string>(modes); }

        IDictionary map = d["policy_enforcement"] as IDictionary;
        if (map == null)
        {
            errors.Add(string.Format("policy_enforcement must be a map of {0} to a mode ({1})",
                string.Join(", ", PolicyEnforcementKeys), string.Join(", ", PolicyEnforcementModes)));
            return new ReadOnlyDictionary<string, string>(modes);
        }

        UnknownKeys(map, PolicyEnforcementKeys, "policy_enforcement", errors);
        foreach (string key in PolicyEnforcementKeys)
        {
            if (!map.Contains(key)) { continue; }
            string mode = Text(map[key]);
            if (Array.IndexOf(PolicyEnforcementModes, mode) < 0)
            {
                errors.Add(string.Format("policy_enforcement.{0}: unknown mode '{1}' (allowed: {2})", key, mode, string.Join(", ", PolicyEnforcementModes)));
            }
            else { modes[key] = mode; }
        }
        return new ReadOnlyDictionary<string, string>(modes);
    }

    private void CheckShortcodes(List<string> errors)
    {
        Dictionary<string, int> count = new Dictionary<string, int>(StringComparer.Ordinal);
        foreach (AzureEnvironmentRecord environment in environments.Values)
        {
            if (environment.shortcode == null) { continue; }
            count[environment.shortcode] = count.TryGetValue(environment.shortcode, out int n) ? n + 1 : 1;
        }
        foreach (KeyValuePair<string, int> pair in count)
        {
            if (pair.Value > 1) { errors.Add(string.Format("Duplicate environment shortcode: '{0}'", pair.Key)); }
        }
    }

    private void CheckReferences(List<string> errors)
    {
        string tenantNames = string.Join(", ", tenants.Keys);
        string environmentNames = string.Join(", ", environments.Keys);
        foreach (AzureSubscriptionRecord subscription in subscriptions.Values)
        {
            if (subscription.tenant != null && !tenants.ContainsKey(subscription.tenant))
            {
                errors.Add(string.Format("subscription '{0}' references unknown tenant '{1}' (valid: {2})", subscription.name, subscription.tenant, tenantNames));
            }

            List<string> perSubscription = new List<string>();
            foreach (string environment in subscription.environments)
            {
                AzureEnvironmentRecord record;
                if (!environments.TryGetValue(environment, out record))
                {
                    errors.Add(string.Format("subscription '{0}' references unknown environment '{1}' (valid: {2})", subscription.name, environment, environmentNames));
                }
                else if (record.per_subscription) { perSubscription.Add(environment); }
            }
            if (perSubscription.Count > 1)
            {
                errors.Add(string.Format("subscription '{0}' lists more than one per-subscription environment ({1}) — at most one is allowed",
                    subscription.name, string.Join(", ", perSubscription)));
            }
        }
    }

    // A configuration/<customer>/<env>[-<slot>].yml config resolves to the customer's ONE subscription serving the env, so no two...
    // [comment:5](/docs/references/automation/catzc-azure/types/AzureConfig.cs.md#comment5)
    private void CheckCustomerDisjointness(List<string> errors)
    {
        Dictionary<string, Dictionary<string, string>> servedBy = new Dictionary<string, Dictionary<string, string>>(StringComparer.Ordinal);
        foreach (AzureSubscriptionRecord subscription in subscriptions.Values)
        {
            if (subscription.customer == null) { continue; }
            Dictionary<string, string> served;
            if (!servedBy.TryGetValue(subscription.customer, out served))
            {
                served = new Dictionary<string, string>(StringComparer.Ordinal);
                servedBy[subscription.customer] = served;
            }
            foreach (string environment in subscription.environments)
            {
                string first;
                if (served.TryGetValue(environment, out first))
                {
                    errors.Add(string.Format("customer '{0}' has more than one subscription serving environment '{1}' ({2}, {3}) — a customer's config resolves to exactly one subscription per environment",
                        subscription.customer, environment, first, subscription.name));
                }
                else { served[environment] = subscription.name; }
            }
        }
    }

    // The entries of a required, non-empty top-level map (name -> mapping); a non-mapping entry passes null so the record reports it.
    // [comment:6](/docs/references/automation/catzc-azure/types/AzureConfig.cs.md#comment6)
    private static List<KeyValuePair<string, IDictionary>> Entries(object value, string key, List<string> errors)
    {
        List<KeyValuePair<string, IDictionary>> entries = new List<KeyValuePair<string, IDictionary>>();
        IDictionary map = value as IDictionary;
        if (value != null && map == null)
        {
            errors.Add(string.Format("'{0}' must be a map keyed by name", key));
            return entries;
        }
        if (map == null || map.Count == 0)
        {
            errors.Add(string.Format("{0} is empty", key));
            return entries;
        }
        foreach (object k in map.Keys)
        {
            entries.Add(new KeyValuePair<string, IDictionary>(Text(k), map[k] as IDictionary));
        }
        return entries;
    }

    // ---- shared helpers for the azure.yml record types ----

    internal static string Text(object value) => value == null ? "" : value.ToString();

    internal static bool IsGuid(string value)
    {
        Guid parsed;
        return Guid.TryParse(value, out parsed);
    }

    // A YAML value as a string list: a sequence is itself, null is empty, and a scalar is a one-item list.
    internal static List<string> Items(object value)
    {
        List<string> items = new List<string>();
        if (value == null) { return items; }
        if (value is string || !(value is IEnumerable)) { items.Add(value.ToString()); return items; }
        foreach (object item in (IEnumerable)value) { if (item != null) { items.Add(item.ToString()); } }
        return items;
    }

    internal static void UnknownKeys(IDictionary d, string[] allowed, string where, List<string> errors)
    {
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(allowed, key) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", where, key, string.Join(", ", allowed)));
            }
        }
    }
}
