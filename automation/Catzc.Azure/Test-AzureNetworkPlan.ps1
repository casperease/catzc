<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-AZ-NETWORK#2
      - ADR-AZ-NETWORK#5
---
#>

<#
.SYNOPSIS
    Quality gate: the network plan (network.yml) and the azure config's environments and subscriptions are in sync.
.DESCRIPTION
    Checks only the join between the two files, since each config validates its own shape on load; lists all violations.
    [comment:1](/docs/references/automation/catzc-azure/Test-AzureNetworkPlan.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-azure-network-plan/ (Write-QualityGateReport).
.PARAMETER PassThru
    Off by default: the gate throws on issues, so a caller that wants to inspect them must opt in.
    [comment:2](/docs/references/automation/catzc-azure/Test-AzureNetworkPlan.ps1.md#comment2)
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-AzureNetworkPlan
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
