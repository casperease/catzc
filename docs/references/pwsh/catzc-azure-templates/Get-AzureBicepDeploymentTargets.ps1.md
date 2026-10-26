# pwsh/Azure.Templates/Get-AzureBicepDeploymentTargets.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
