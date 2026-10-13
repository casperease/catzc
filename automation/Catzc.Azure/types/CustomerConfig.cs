// The customer catalogue (configs/customer.yml, [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)) — the
// customers this repo can deploy for; WHICH of them are enabled is the have_customers variant, not this file.
// Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.CustomerConfig), so
// Get-Config -Config customer returns this typed record. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - the top-level key 'customers' is required (an empty map is allowed) and is the only key;
//   - every entry is a well-formed AzureCustomer (key and shortcode formats);
//   - shortcodes are unique;
//   - no key equals any shortcode — a subscription's `customer` field may name a customer by its key OR its
//     shortcode, so a collision would make that reference ambiguous
//     ([ADR-AZ-CUSTOMER#2](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer2)).
// Self-contained — it does NOT read azure.yml (a subscription references a customer here, so azure.yml depends
// on customer.yml, never the reverse; [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)).

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

public sealed class CustomerConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The catalogue, keyed by customer key in file order (a Dictionary enumerates in insertion order when nothing
    // is removed, and this one is never mutated after construction).
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
