// One customer of the catalogue (configs/customer.yml, [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)):
// a readable key (the customers-map key — the customer-segment of relaxed resource names and the configuration
// subfolder name), a 2-char shortcode (the customer-segment of the restricted kv/storage/vm patterns), and optional
// free-text details. Mirrors a `customers` entry (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `key` is the map key.
//
// Constructing an instance validates the entry, collecting every violation into one ArgumentException: the key is
// 2+ lowercase alphanumeric with a leading letter, the shortcode is exactly 2 lowercase letters, and the entry
// carries no key but shortcode and details. Catalogue-wide rules (shortcode uniqueness, key ≠ any shortcode) are
// CustomerConfig's.

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
