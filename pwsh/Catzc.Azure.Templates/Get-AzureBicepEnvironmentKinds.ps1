<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
    name: get-azure-bicep-environment-kinds
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureBicepEnvironmentKinds.Tests.ps1
    docs: "[Get-AzureBicepEnvironmentKinds.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureBicepEnvironmentKinds.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD
---
#>

function Get-AzureBicepEnvironmentKinds {
    param()
    @('standard', 'subscription')
}
