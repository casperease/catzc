<#
---
catzc:
  immutable:
    with_body_sha: "6d54b511fe5f"
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
