// catzc:
//   path: automation/Catzc.Azure/types/CustomerConfig.cs
//   module: Catzc.Azure

// Self-contained: azure.yml depends on customer.yml, never the reverse, so this type never reads azure.yml.
// [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-AZ-CUSTOMER#2](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer2),
// [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)
// [comment:1](/docs/references/automation/catzc-azure/types/CustomerConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

public sealed class CustomerConfig : Catzc.Base.Objects.DictionaryRecord
{
    // File order is kept: a Dictionary enumerates in insertion order when nothing is removed, and this one is never mutated.
    // [comment:2](/docs/references/automation/catzc-azure/types/CustomerConfig.cs.md#comment2)
    public IReadOnlyDictionary<string, AzureCustomer> customers { get; }

    public CustomerConfig(IDictionary d)
    {
        if (d == null || !d.Contains("customers"))
        {
            throw new ArgumentException("customer configuration validation failed:\nMissing required top-level key: 'customers'");
        }

        List<string> errors = new List<string>();
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "customers") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: customers)", key)); }
        }

        Dictionary<string, AzureCustomer> map = new Dictionary<string, AzureCustomer>(StringComparer.Ordinal);
        customers = map;
        IDictionary raw = d["customers"] as IDictionary;
        if (d["customers"] != null && raw == null)
        {
            errors.Add("'customers' must be a map of customer key -> { shortcode [, details] }");
        }

        List<string> names = new List<string>();
        Dictionary<string, int> shortcodeCount = new Dictionary<string, int>(StringComparer.Ordinal);
        if (raw != null)
        {
            foreach (object k in raw.Keys)
            {
                string name = k == null ? null : k.ToString();
                names.Add(name);
                try
                {
                    AzureCustomer customer = new AzureCustomer(name, raw[k] as IDictionary);
                    map[name] = customer;
                    shortcodeCount[customer.shortcode] = shortcodeCount.TryGetValue(customer.shortcode, out int n) ? n + 1 : 1;
                }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }

        foreach (KeyValuePair<string, int> pair in shortcodeCount)
        {
            if (pair.Value > 1) { errors.Add(string.Format("Duplicate customer shortcode: '{0}'", pair.Key)); }
        }

        foreach (string name in names)
        {
            if (name != null && shortcodeCount.ContainsKey(name))
            {
                errors.Add(string.Format("customer name '{0}' collides with a customer shortcode — keys and shortcodes must be distinct so a subscription's 'customer' reference is unambiguous", name));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException("customer configuration validation failed:\n" + string.Join("\n", errors)); }
    }
}
