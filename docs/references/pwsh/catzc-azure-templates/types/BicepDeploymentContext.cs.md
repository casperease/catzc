# pwsh/Azure.Templates/types/BicepDeploymentContext.cs

The typed record of everything one Bicep deploy needs, gathered into three concerns: the plan (what and where to deploy), the artifacts
(which files) and the resolved environment identity (which subscription and tenant). The deploy of a DoNotRun template yields no context at
all, since the producer returns null instead of this record.
