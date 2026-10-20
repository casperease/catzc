<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure/Get-AzureBicepMinVersion.ps1
    name: get-azure-bicep-min-version
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
    docs: "[Get-AzureBicepMinVersion.ps1.md](docs/references/pwsh/catzc-azure/Get-AzureBicepMinVersion.ps1.md)"
---
#>

function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
