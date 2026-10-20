<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
    name: get-azure-bicep-deployment-modes
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
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentModes.Tests.ps1
    docs: "[Get-AzureBicepDeploymentModes.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureBicepDeploymentModes.ps1.md)"
---
#>

function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
