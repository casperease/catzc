// Everything one Bicep deploy needs, gathered into three concerns: the plan (what/where to deploy), the
// artifacts (which files), and the resolved environment identity (which subscription/tenant). The deploy
// of a DoNotRun template yields no context at all (the producer returns null instead of this).

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepDeploymentContext
{
    // What and where to deploy. Always present.
    public BicepDeploymentPlan        deployment  { get; }

    // The files to deploy. Always present.
    public BicepArtifacts             artifacts   { get; }

    // The resolved environment identity, including the serving subscription and its tenant. Always present.
    public Catzc.Azure.AzureEnvironment environment { get; }

    public BicepDeploymentContext(BicepDeploymentPlan deployment, BicepArtifacts artifacts, Catzc.Azure.AzureEnvironment environment)
    {
        if (deployment == null)  { throw new ArgumentException("BicepDeploymentContext.deployment is required"); }
        if (artifacts == null)   { throw new ArgumentException("BicepDeploymentContext.artifacts is required"); }
        if (environment == null) { throw new ArgumentException("BicepDeploymentContext.environment is required"); }
        this.deployment  = deployment;
        this.artifacts   = artifacts;
        this.environment = environment;
    }
}
