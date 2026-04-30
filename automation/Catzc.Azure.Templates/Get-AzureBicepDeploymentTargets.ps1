<#
.SYNOPSIS
    Returns the supported bicep deployment target scopes.
.DESCRIPTION
    'ResourceGroup' — deploys into a named resource group (the common case).
    'Subscription'  — deploys at the subscription scope (for cross-RG resources).
.EXAMPLE
    Get-AzureBicepDeploymentTargets
#>
function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
