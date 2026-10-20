<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure/Test-AzureNetworkPlan.ps1
    name: test-azure-network-plan
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
