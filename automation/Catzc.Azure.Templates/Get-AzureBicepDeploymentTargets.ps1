<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the supported bicep deployment target scopes.
.DESCRIPTION
    Pick Subscription only for resources that span resource groups; ResourceGroup is the common case.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureBicepDeploymentTargets.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepDeploymentTargets
#>
function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
