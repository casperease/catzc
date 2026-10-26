using System;

namespace Catzc.Azure.Templates;

// One config file bound to one (customer, environment, slot) coordinate, hence one subscription and one resource group.
public sealed class BicepSlot
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The slot's deployment name. Always present.
    public string name { get; }

    // The environment this slot deploys into. Always present.
    public string environment { get; }

    // The empty string, never null, is the base slot: downstream resolves slots by value (slot -eq '').
    public string slot { get; }

    // Resolved at discovery from the slot's coordinate, so it is always present.
    public string subscription { get; }

    // The empty string, never null, marks a shared configuration-root slot: downstream filters by value (customer -eq '').
    public string customer { get; }

    // The slot's config file, a .yml or a .bicepparam under the template's configuration folder.
    public string file { get; }

    // From the config's extension: yml or bicepparam.
    public string format { get; }

    public const string YmlFormat = "yml";

    public const string BicepparamFormat = "bicepparam";

    public BicepSlot(string name, string environment, string slot, string subscription, string customer, string file)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("BicepSlot.name is required"); }
        if (string.IsNullOrWhiteSpace(environment)) { throw new ArgumentException("BicepSlot.environment is required"); }
        if (string.IsNullOrWhiteSpace(subscription)) { throw new ArgumentException("BicepSlot.subscription is required"); }
        if (string.IsNullOrWhiteSpace(file)) { throw new ArgumentException("BicepSlot.file is required"); }
        string extension = System.IO.Path.GetExtension(file);
        if (string.Equals(extension, ".yml", StringComparison.Ordinal)) { format = YmlFormat; }
        else if (string.Equals(extension, ".bicepparam", StringComparison.Ordinal)) { format = BicepparamFormat; }
        else { throw new ArgumentException("BicepSlot.file must be a .yml or a .bicepparam config, not '" + file + "'"); }
        this.name = name;
        this.environment = environment;
        this.slot = slot ?? "";        // "" sentinel — compared by value downstream
        this.subscription = subscription;
        this.customer = customer ?? "";    // "" sentinel — compared by value downstream
        this.file = file;
    }
}
