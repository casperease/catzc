/*
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/types/BicepDeploymentContext.cs
    folder: types
    name: bicep-deployment-context
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-templates/types/BicepDeploymentContext.cs.md
---
*/

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
