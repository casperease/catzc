<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the supported bicep deployment modes.
.DESCRIPTION
    Complete deletes resources in the target scope that the template omits; Incremental never does.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureBicepDeploymentModes.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepDeploymentModes
#>
function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
