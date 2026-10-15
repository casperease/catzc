<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
    kind: public-function
    module: Catzc.Azure.Templates
    visibility: public
  config:
    synopsis: Returns the supported bicep deployment target scopes.
    description: |-
      'ResourceGroup' — deploys into a named resource group (the common case).
      'Subscription'  — deploys at the subscription scope (for cross-RG resources).
    examples:
      - Get-AzureBicepDeploymentTargets
---
#>

function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
