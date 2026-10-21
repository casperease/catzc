<#
---
catzc:
  immutable:
    with_body_sha: "4203b1b82700"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentModes.Tests.ps1
    docs: "[Get-AzureBicepDeploymentModes.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureBicepDeploymentModes.ps1.md)"
---
#>

function Get-AzureBicepDeploymentModes {
    param()
    @('Incremental', 'Complete', 'DoNotRun')
}
