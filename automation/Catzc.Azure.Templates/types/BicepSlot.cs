// One deployable slot of a template: the unit binding one config file to one (customer?, environment,
// slot) coordinate, which resolves to one subscription and one resource group. Nested into
// BicepTemplate.slots — a template fans out into one BicepSlot per deployable coordinate.

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepSlot
{
    // The slot's deployment name. Always present.
    public string name         { get; }

    // The environment this slot deploys into. Always present.
    public string environment  { get; }

    // The slot discriminator within the environment. The empty string "" (NOT null) is the base/index-0
    // slot — kept as a sentinel because downstream resolves slots by value (`slot -eq ''` for the base).
    public string slot         { get; }

    // The subscription this slot deploys into — resolved at discovery from the slot's coordinate: the
    // one non-customer subscription serving the env (a configuration-root config), or the customer's one
    // subscription serving it (a configuration/<customer>/ config). Always present.
    public string subscription { get; }

    // The customer this slot is for — the configuration subfolder name (a customer key). The empty
    // string "" (NOT null) for a configuration-root (shared) slot — a sentinel because downstream
    // filters by value (`customer -eq ''`).
    public string customer     { get; }

    public BicepSlot(string name, string environment, string slot, string subscription, string customer)
    {
        if (string.IsNullOrWhiteSpace(name))         { throw new ArgumentException("BicepSlot.name is required"); }
        if (string.IsNullOrWhiteSpace(environment))  { throw new ArgumentException("BicepSlot.environment is required"); }
        if (string.IsNullOrWhiteSpace(subscription)) { throw new ArgumentException("BicepSlot.subscription is required"); }
        this.name         = name;
        this.environment  = environment;
        this.slot         = slot ?? "";        // "" sentinel — compared by value downstream
        this.subscription = subscription;
        this.customer     = customer ?? "";    // "" sentinel — compared by value downstream
    }
}
