<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the supported bicep deployment modes.
.DESCRIPTION
    Complete deletes resources in the target scope that the template omits; Incremental never does.
.EXAMPLE
    Get-AzureBicepDeploymentModes
#>
function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
