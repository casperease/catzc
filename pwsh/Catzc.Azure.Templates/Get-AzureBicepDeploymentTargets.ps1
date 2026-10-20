<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
    name: get-azure-bicep-deployment-targets
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
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentTargets.Tests.ps1
    docs: "[Get-AzureBicepDeploymentTargets.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureBicepDeploymentTargets.ps1.md)"
---
#>

function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
