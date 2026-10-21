<#
---
catzc:
  immutable:
    with_body_sha: "565905c6b775"
  edges:
    test: pwsh/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
    docs: "[Test-AzureNetworkPlan.ps1.md](docs/references/pwsh/catzc-azure/Test-AzureNetworkPlan.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-AZ-NETWORK-KEYEDBYENVIRONMENT
      - ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION
---
#>

function Test-AzureNetworkPlan {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $network = Get-Config -Config network
    $issues = @(Get-NetworkPlanViolations -Network $network -Azure (Get-Config -Config azure))

    $facts = [ordered]@{ Environments = $network.environments.Count; Subscriptions = $network.subscriptions.Count }
    Write-QualityGateReport -Subject 'azure-network-plan' -Title 'Test-AzureNetworkPlan' -Issues $issues `
        -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
