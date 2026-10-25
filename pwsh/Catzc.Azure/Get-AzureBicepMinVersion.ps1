<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure/Get-AzureBicepMinVersion.ps1.md"
  warning: "Generated Header"
---
#>

function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
