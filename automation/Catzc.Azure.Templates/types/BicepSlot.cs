/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/types/BicepSlot.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md
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
