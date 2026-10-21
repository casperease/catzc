<#
---
catzc:
  immutable:
    with_body_sha: f416e679c3a3
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
