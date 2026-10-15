<#
.SYNOPSIS
    Quality gate: the network plan (network.yml) and the azure config's environments and subscriptions are in sync.
.DESCRIPTION
    A quality gate over the cross-asset join of and.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2),
    [ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5)
    [comment:1](/docs/references/automation/catzc-azure/Test-AzureNetworkPlan.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-azure-network-plan/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Environments; Subscriptions }) instead of throwing...
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
