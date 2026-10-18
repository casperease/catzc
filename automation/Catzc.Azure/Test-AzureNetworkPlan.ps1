<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
    name: test-azure-network-plan
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-AZ-NETWORK#{2,5}
---
#>

function Test-AzureNetworkPlan {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
