<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the supported bicep deployment target scopes.
.DESCRIPTION
    Pick Subscription only for resources that span resource groups; ResourceGroup is the common case.
.EXAMPLE
    Get-AzureBicepDeploymentTargets
#>
function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
