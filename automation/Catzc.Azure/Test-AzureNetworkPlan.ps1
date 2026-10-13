<#
.SYNOPSIS
    Quality gate: the network plan (network.yml) and the azure config's environments are in sync.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
    cross-asset join of [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2). Each config
    validates its own shape when Get-Config loads it; this gate checks what neither file can check alone: every network
    environment is a defined azure.yml environment, and every standard azure.yml environment has a network entry
    (per-subscription environments are exempt). It lists every violation.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-azure-network-plan/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Environments }) instead of throwing on issues.
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

    Write-QualityGateReport -Subject 'azure-network-plan' -Title 'Test-AzureNetworkPlan' -Issues $issues `
        -Facts ([ordered]@{ Environments = $network.environments.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
