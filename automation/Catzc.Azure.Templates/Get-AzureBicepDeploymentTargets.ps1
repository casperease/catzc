<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
    kind: automation-function
    module: Catzc.Azure.Templates
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentTargets.Tests.ps1
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
