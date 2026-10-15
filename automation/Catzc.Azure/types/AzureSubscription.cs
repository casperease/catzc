/*
---
catzc:
  derived:
    path: automation/Catzc.Azure/types/AzureSubscription.cs
    kind: type
    module: Catzc.Azure
    adrs: []
---
*/

// A mid node of the identity graph, so its property names are the YAML keys verbatim.
// [comment:1](/docs/references/automation/catzc-azure/types/AzureSubscription.cs.md#comment1)

using System;

namespace Catzc.Azure;

public sealed class AzureSubscription
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Logical subscription name — the azure.yml `subscriptions` map key. Always present.
    public string name { get; }

    // The Azure subscription GUID. Always present.
    public string id { get; }

    // Null for a platform subscription, so a typed null check separates the two kinds; otherwise it renders into resource names.
    // [comment:2](/docs/references/automation/catzc-azure/types/AzureSubscription.cs.md#comment2)
    public string customer { get; }

    // The Entra tenant that owns this subscription. Always present.
    public Tenant tenant { get; }

    public AzureSubscription(string name, string id, string customer, Tenant tenant)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("AzureSubscription.name is required"); }
        if (string.IsNullOrWhiteSpace(id)) { throw new ArgumentException("AzureSubscription.id is required"); }
        if (tenant == null) { throw new ArgumentException("AzureSubscription.tenant is required"); }
        this.name = name;
        this.id = id;
        // An absent/blank customer collapses to null, so the typed null-check reads false for "no customer".
        this.customer = string.IsNullOrWhiteSpace(customer) ? null : customer;
        this.tenant = tenant;
    }
}
