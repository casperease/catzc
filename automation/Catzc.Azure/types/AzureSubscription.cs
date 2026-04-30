// A resolved subscription identity: a named Azure subscription, the Entra tenant that owns it, and —
// for customer subscriptions only — the customer it serves. A mid node of the identity graph
// (Tenant ← AzureSubscription ← AzureEnvironment). Mirrors a `subscriptions` entry in configs/azure.yml,
// so the property names are the YAML keys verbatim.

using System;

namespace Catzc.Azure;

public sealed class AzureSubscription
{
    // Logical subscription name — the azure.yml `subscriptions` map key. Always present.
    public string name     { get; }

    // The Azure subscription GUID. Always present.
    public string id       { get; }

    // The customer this subscription serves; this value renders into customer resource names. Null for a
    // non-customer (platform/shared) subscription, so a typed null-check separates the two kinds.
    public string customer { get; }

    // The Entra tenant that owns this subscription. Always present.
    public Tenant tenant   { get; }

    public AzureSubscription(string name, string id, string customer, Tenant tenant)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("AzureSubscription.name is required"); }
        if (string.IsNullOrWhiteSpace(id))   { throw new ArgumentException("AzureSubscription.id is required"); }
        if (tenant == null)                  { throw new ArgumentException("AzureSubscription.tenant is required"); }
        this.name     = name;
        this.id       = id;
        // An absent/blank customer collapses to null, so the typed null-check reads false for "no customer".
        this.customer = string.IsNullOrWhiteSpace(customer) ? null : customer;
        this.tenant   = tenant;
    }
}
