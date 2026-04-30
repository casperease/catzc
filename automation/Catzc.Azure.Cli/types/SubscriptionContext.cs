// A snapshot of the az CLI's currently active subscription (the shape of `az account show`). Captured so
// it can be saved and later restored around a subscription switch.

using System;

namespace Catzc.Azure.Cli;

public sealed class SubscriptionContext
{
    // The active subscription GUID. Always present.
    public string Id        { get; }

    // The active subscription's display name. Always present.
    public string Name      { get; }

    // The Entra tenant GUID the subscription belongs to.
    public string TenantId  { get; }

    // The subscription's lifecycle state as az reports it (e.g. `Enabled`).
    public string State     { get; }

    // True when this is the CLI's default subscription.
    public bool   IsDefault { get; }

    public SubscriptionContext(string id, string name, string tenantId, string state, bool isDefault)
    {
        if (string.IsNullOrWhiteSpace(id))   { throw new ArgumentException("SubscriptionContext.Id is required"); }
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("SubscriptionContext.Name is required"); }
        this.Id        = id;
        this.Name      = name;
        this.TenantId  = tenantId;
        this.State     = state;
        this.IsDefault = isDefault;
    }
}
