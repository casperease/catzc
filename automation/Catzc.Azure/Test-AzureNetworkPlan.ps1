<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
    name: test-azure-network-plan
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-AZ-NETWORK#{2,5}
  config:
    synopsis: 'Quality gate: the network plan (network.yml) and the azure config''s environments and subscriptions are in sync.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
      cross-asset join of [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2) and
      [ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5). Each config validates its own
      shape when Get-Config loads it; this gate checks what neither file can check alone: every network environment is a
      defined azure.yml environment, and every standard azure.yml environment has a network entry (per-subscription
      environments are exempt); every network subscription is a defined azure.yml subscription, every azure.yml
      subscription has a hub (no customer) or a spoke (a customer), and a spoke has a workload subnet for each standard
      environment its subscription serves, and no other. It lists every violation.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-azure-network-plan/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; Environments; Subscriptions }) instead of throwing on
        issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-AzureNetworkPlan
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
