// catzc:
//   path: automation/Catzc.Azure.Templates/types/BicepSlot.cs
//   module: Catzc.Azure.Templates

// A template fans out into one slot per deployable coordinate, each resolving to one subscription and one resource group.
// [comment:1](/docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md#comment1)

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepSlot
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The slot's deployment name. Always present.
    public string name { get; }

    // The environment this slot deploys into. Always present.
    public string environment { get; }

    // The empty string, never null, marks the base slot, because downstream compares slots by value.
    // [comment:2](/docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md#comment2)
    public string slot { get; }

    // Always present: discovery resolves it from the coordinate to exactly one subscription.
    // [comment:3](/docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md#comment3)
    public string subscription { get; }

    // The empty string, never null, marks a shared configuration-root slot, because downstream filters by value.
    // [comment:4](/docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md#comment4)
    public string customer { get; }

    public BicepSlot(string name, string environment, string slot, string subscription, string customer)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("BicepSlot.name is required"); }
        if (string.IsNullOrWhiteSpace(environment)) { throw new ArgumentException("BicepSlot.environment is required"); }
        if (string.IsNullOrWhiteSpace(subscription)) { throw new ArgumentException("BicepSlot.subscription is required"); }
        this.name = name;
        this.environment = environment;
        this.slot = slot ?? "";        // "" sentinel — compared by value downstream
        this.subscription = subscription;
        this.customer = customer ?? "";    // "" sentinel — compared by value downstream
    }
}
