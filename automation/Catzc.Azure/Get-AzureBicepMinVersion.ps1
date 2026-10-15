<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureBicepMinVersion.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the minimum required Bicep CLI version from azure.yml.
.DESCRIPTION
    Returned as a version object, not text, so 0.9.0 correctly compares below 0.30.0.
.EXAMPLE
    Get-AzureBicepMinVersion   # -> 0.30.0
#>
function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
