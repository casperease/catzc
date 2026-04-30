<#
.SYNOPSIS
    Returns the minimum required Bicep CLI version from azure.yml.
.DESCRIPTION
    Reads the required `bicep_min_version` global from configs/azure.yml (validated as MAJOR.MINOR.PATCH
    by Assert-AzureConfig on load) and returns it as a [version] for comparison. Assert-AzCliBicep /
    Test-AzCliBicep use it to gate `az bicep build`.
.EXAMPLE
    Get-AzureBicepMinVersion   # -> 0.30.0
#>
function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
