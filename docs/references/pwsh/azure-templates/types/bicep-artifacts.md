# pwsh/Azure.Templates/types/BicepArtifacts.cs

The typed build-artifacts concern of a deployment: the concrete files a Bicep deploy hands to az. Paths are stored repo-root-relative where
possible. It is one of the three concerns nested in `BicepDeploymentContext`.
