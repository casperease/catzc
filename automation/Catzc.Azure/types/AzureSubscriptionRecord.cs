/*
---
catzc:
  derived:
    path: automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
    kind: type
    module: Catzc.Azure
---
*/

// The customer stays a raw token here; a test and runtime resolution check it, and AzureConfig checks the tenant.
// [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md), [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8), [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)
// [comment:1](/docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class AzureSubscriptionRecord : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "id", "tenant", "environments", "customer" };

    // The subscription's logical name (the map key).
    public string name { get; }

    // The Azure subscription GUID. Null when missing or invalid (a violation is recorded).
    public string id { get; }

    // The owning tenant's name (a `tenants` key). Null when missing.
    public string tenant { get; }

    // The raw customer token (a customer.yml key or shortcode). Null for a non-customer subscription.
    public string customer { get; }

    // The environments this subscription serves (`environments` keys), in file order.
    public string[] environments { get; }

    // Builds the record and throws one ArgumentException listing every violation.
    public AzureSubscriptionRecord(string name, IDictionary d) : this(name, d, null) { }

    // Builds the record best-effort, appending every violation to `errors` (throws only when `errors` is null).
    internal AzureSubscriptionRecord(string name, IDictionary d, List<string> errors)
    {
        List<string> own = errors ?? new List<string>();
        int before = own.Count;
        this.name = name;
        environments = new string[0];

        if (name == null || !Regex.IsMatch(name, AzureConfig.IdentifierPattern))
        {
            own.Add(string.Format("subscription name '{0}' is not a valid identifier (must match {1})", name, AzureConfig.IdentifierPattern));
        }
        if (d == null)
        {
            own.Add(string.Format("subscription '{0}' must be a mapping with id, tenant, environments", name));
        }
        else
        {
            AzureConfig.UnknownKeys(d, AllowedKeys, string.Format("subscription '{0}'", name), own);

            if (!d.Contains("id")) { own.Add(string.Format("subscription '{0}' missing 'id'", name)); }
            else
            {
                string value = AzureConfig.Text(d["id"]);
                if (AzureConfig.IsGuid(value)) { id = value; }
                else { own.Add(string.Format("subscription '{0}' has invalid id '{1}' (must be a GUID)", name, value)); }
            }

            if (!d.Contains("tenant")) { own.Add(string.Format("subscription '{0}' missing 'tenant'", name)); }
            else { tenant = AzureConfig.Text(d["tenant"]); }

            if (!d.Contains("environments")) { own.Add(string.Format("subscription '{0}' missing 'environments'", name)); }
            else
            {
                environments = AzureConfig.Items(d["environments"]).ToArray();
                if (environments.Length == 0) { own.Add(string.Format("subscription '{0}' has empty 'environments'", name)); }
            }

            customer = OptStr(d, "customer");
        }

        if (errors == null && own.Count > before) { throw new ArgumentException(string.Join("\n", own)); }
    }
}
