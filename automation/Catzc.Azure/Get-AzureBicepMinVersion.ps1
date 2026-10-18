<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/Get-AzureBicepMinVersion.ps1
    name: get-azure-bicep-min-version
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
---
#>

function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
