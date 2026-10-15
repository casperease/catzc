/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/types/SubscriptionContext.cs
    kind: type
    module: Catzc.Azure.Cli
    adrs: []
---
*/

// Captured so the active subscription can be saved and later restored around a subscription switch.
// [comment:1](/docs/references/automation/catzc-azure-cli/types/SubscriptionContext.cs.md#comment1)

using System;

namespace Catzc.Azure.Cli;

public sealed class SubscriptionContext
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The active subscription GUID. Always present.
    public string Id { get; }

    // The active subscription's display name. Always present.
    public string Name { get; }

    // The Entra tenant GUID the subscription belongs to.
    public string TenantId { get; }

    // The subscription's lifecycle state as az reports it (e.g. `Enabled`).
    public string State { get; }

    // True when this is the CLI's default subscription.
    public bool IsDefault { get; }

    public SubscriptionContext(string id, string name, string tenantId, string state, bool isDefault)
    {
        if (string.IsNullOrWhiteSpace(id)) { throw new ArgumentException("SubscriptionContext.Id is required"); }
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("SubscriptionContext.Name is required"); }
        this.Id = id;
        this.Name = name;
        this.TenantId = tenantId;
        this.State = state;
        this.IsDefault = isDefault;
    }
}
