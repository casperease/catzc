# pwsh/Azure.Templates/Get-AzureBicepDeploymentTargets.ps1

The function that returns the bicep deployment target scopes the deploy supports.

## help

### synopsis

Returns the supported bicep deployment target scopes.

### description

'ResourceGroup' — deploys into a named resource group (the common case). 'Subscription' — deploys at the subscription scope (for cross-RG
resources).

### example 1

```powershell
Get-AzureBicepDeploymentTargets
```
