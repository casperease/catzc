<#
.SYNOPSIS
    Returns the minimum required Bicep CLI version from azure.yml.
.DESCRIPTION
    Reads the required `bicep_min_version` global from configs/azure.yml (validated as MAJOR.MINOR.PATCH by the...
    [comment:1](/docs/references/automation/catzc-azure/Get-AzureBicepMinVersion.ps1.md#comment1)
.EXAMPLE
    Get-AzureBicepMinVersion   # -> 0.30.0
#>
function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
