<#
.SYNOPSIS
    Returns the supported bicep deployment target scopes.
.DESCRIPTION
    'ResourceGroup' — deploys into a named resource group (the common case).
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureBicepDeploymentTargets.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepDeploymentTargets
#>
function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
