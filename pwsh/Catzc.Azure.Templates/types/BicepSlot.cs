/*
---
catzc:
  immutable:
    with_body_sha: e85047352cde
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/types/BicepSlot.Tests.ps1
    docs: "[BicepSlot.cs.md](docs/references/pwsh/catzc-azure-templates/types/BicepSlot.cs.md)"
    cites:
      - ADR-AZ-DATAMOD-BICEPPARAMSLOT
---
*/

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepSlot
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The slot's deployment name. Always present.
    public string name { get; }

    // The environment this slot deploys into. Always present.
    public string environment { get; }

    public string slot { get; }

    public string subscription { get; }

    public string customer { get; }

    // The slot's config file, a .yml or a .bicepparam under the template's configuration folder.
    public string file { get; }

    // The config's source format, from its extension: yml or bicepparam
    // ([ADR-AZ-DATAMOD-BICEPPARAMSLOT](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-bicepparamslot)).
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
