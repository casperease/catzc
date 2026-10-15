<#
.SYNOPSIS
    Returns the supported template environment kinds (which env class a template binds to).
.DESCRIPTION
    A subscription environment appears exactly once per subscription; a standard one may appear many times.
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepEnvironmentKinds
#>
function Get-AzureBicepEnvironmentKinds {
    param()
    @('standard', 'subscription')
}
