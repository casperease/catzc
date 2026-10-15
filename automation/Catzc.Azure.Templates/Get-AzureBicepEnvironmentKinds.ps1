<#
.SYNOPSIS
    Returns the supported template environment kinds (which env class a template binds to).
.DESCRIPTION
    'standard' (default) — the template's configs use standard environments (dev/test/preprod/prod), which may appear...
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepEnvironmentKinds
#>
function Get-AzureBicepEnvironmentKinds {
    param()
    @('standard', 'subscription')
}
