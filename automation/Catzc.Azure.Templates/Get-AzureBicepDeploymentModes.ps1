<#
.SYNOPSIS
    Returns the supported bicep deployment modes.
.DESCRIPTION
    'Incremental' (default) — additive update; existing resources outside the template are preserved.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureBicepDeploymentModes.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepDeploymentModes
#>
function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
