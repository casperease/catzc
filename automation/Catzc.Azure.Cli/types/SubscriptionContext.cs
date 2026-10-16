/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/types/SubscriptionContext.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-cli/types/SubscriptionContext.cs.md
---
*/

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
