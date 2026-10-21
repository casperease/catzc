<#
---
catzc:
  immutable:
    with_body_sha: "35ee9e71eeda"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentTargets.Tests.ps1
    docs: "[Get-AzureBicepDeploymentTargets.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Get-AzureBicepDeploymentTargets.ps1.md)"
---
#>

function Get-AzureBicepDeploymentTargets {
    param()
    @('ResourceGroup', 'Subscription')
}
