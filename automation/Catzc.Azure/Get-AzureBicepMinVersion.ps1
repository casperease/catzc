<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureBicepMinVersion.ps1
    kind: automation-function
    module: Catzc.Azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
  config:
    synopsis: Returns the minimum required Bicep CLI version from azure.yml.
    description: |-
      Reads the required `bicep_min_version` global from configs/azure.yml (validated as MAJOR.MINOR.PATCH
      by the AzureConfig type on load) and returns it as a [version] for comparison. Assert-AzCliBicep /
      Test-AzCliBicep use it to decide whether `az bicep build` may run.
    examples:
      - 'Get-AzureBicepMinVersion   # -> 0.30.0'
---
#>

function Get-AzureBicepMinVersion {
    [OutputType([version])]
    param()

    $azure = Get-Config -Config azure
    [version]"$($azure.bicep_min_version)"
}
