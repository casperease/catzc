// The deployment-plan concern of a deployment: what to deploy and where, independent of the files
// (those are BicepArtifacts). One of the three concerns nested in BicepDeploymentContext.

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepDeploymentPlan
{
    // The template being deployed (its name). Always present.
    public string template       { get; }

    // The deployment name az records this run under. Always present.
    public string name           { get; }

    // The deployment mode (e.g. Incremental / Complete). Always present.
    public string mode           { get; }

    // The deployment scope target (e.g. ResourceGroup / Subscription). Always present.
    public string target         { get; }

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
