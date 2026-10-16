/*
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/types/BicepDeploymentPlan.cs
    folder: types
    name: bicep-deployment-plan
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/types/BicepDeploymentPlan.cs.md
---
*/

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepDeploymentPlan
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The template being deployed (its name). Always present.
    public string template { get; }

    // The deployment name az records this run under. Always present.
    public string name { get; }

    // The deployment mode (e.g. Incremental / Complete). Always present.
    public string mode { get; }

    // The deployment scope target (e.g. ResourceGroup / Subscription). Always present.
    public string target { get; }

    // The target resource group. Null for a Subscription-target deployment, which has no resource group.
    public string resource_group { get; }

    public BicepDeploymentPlan(string template, string name, string mode, string target, string resource_group)
    {
        if (string.IsNullOrWhiteSpace(template)) { throw new ArgumentException("BicepDeploymentPlan.template is required"); }
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("BicepDeploymentPlan.name is required"); }
        if (string.IsNullOrWhiteSpace(mode)) { throw new ArgumentException("BicepDeploymentPlan.mode is required"); }
        if (string.IsNullOrWhiteSpace(target)) { throw new ArgumentException("BicepDeploymentPlan.target is required"); }
        this.template = template;
        this.name = name;
        this.mode = mode;
        this.target = target;
        this.resource_group = string.IsNullOrWhiteSpace(resource_group) ? null : resource_group;
    }
}
