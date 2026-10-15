/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/types/BicepDeploymentContext.cs
    kind: csharp-type
    module: Catzc.Azure.Templates
---
*/

// A DoNotRun template yields no context at all: the producer returns null instead of this type.
// [comment:1](/docs/references/automation/catzc-azure-templates/types/BicepDeploymentContext.cs.md#comment1)

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepDeploymentContext
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // What and where to deploy. Always present.
    public BicepDeploymentPlan deployment { get; }

    // The files to deploy. Always present.
    public BicepArtifacts artifacts { get; }

    // The resolved environment identity, including the serving subscription and its tenant. Always present.
    public Catzc.Azure.AzureEnvironment environment { get; }

    public BicepDeploymentContext(BicepDeploymentPlan deployment, BicepArtifacts artifacts, Catzc.Azure.AzureEnvironment environment)
    {
        if (deployment == null) { throw new ArgumentException("BicepDeploymentContext.deployment is required"); }
        if (artifacts == null) { throw new ArgumentException("BicepDeploymentContext.artifacts is required"); }
        if (environment == null) { throw new ArgumentException("BicepDeploymentContext.environment is required"); }
        this.deployment = deployment;
        this.artifacts = artifacts;
        this.environment = environment;
    }
}
