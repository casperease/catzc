// One customer of the catalogue (configs/customer.yml, ): a readable key (the customers-map key — the customer-segment of relaxed...
// [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-azure/types/AzureCustomer.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class AzureCustomer : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "shortcode", "details" };

    // The canonical customer key (the customers-map key).
    public string key { get; }

    // The unique 2-char shortcode.
    public string shortcode { get; }

    // A free-text label. Null when absent.
    public string details { get; }

    public AzureCustomer(string key, IDictionary d)
    {
        List<string> errors = new List<string>();
        if (key == null || !Regex.IsMatch(key, "^[a-z][a-z0-9]+$"))
        {
            errors.Add(string.Format("customer name '{0}' is invalid (must be 2+ lowercase alphanumeric chars, leading letter)", key));
        }
        this.key = key;

        if (d == null)
        {
            errors.Add(string.Format("customer '{0}' must be a mapping with a 'shortcode'", key));
        }
        else
        {
            foreach (object k in d.Keys)
            {
                string field = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, field) < 0)
                {
                    errors.Add(string.Format("customer '{0}': unknown key '{1}' (allowed: {2})", key, field, string.Join(", ", AllowedKeys)));
                }
            }
            if (!d.Contains("shortcode"))
            {
                errors.Add(string.Format("customer '{0}' is missing 'shortcode'", key));
            }
            else
            {
                string code = d["shortcode"] == null ? "" : d["shortcode"].ToString();
                if (Regex.IsMatch(code, "^[a-z]{2}$")) { shortcode = code; }
                else { errors.Add(string.Format("customer '{0}' has invalid shortcode '{1}' (must be 2 lowercase letters)", key, code)); }
            }
            details = OptStr(d, "details");
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
