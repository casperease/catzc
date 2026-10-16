<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
    name: get-azure-bicep-deployment-targets
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
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
