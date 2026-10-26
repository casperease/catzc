# pwsh/Azure/Test-AzureNetworkPlan.ps1

The quality gate that keeps the network plan and the Azure identity config in step. It runs the join of `Get-NetworkPlanViolations` over the
two shipped configs and reports every violation, so an environment or subscription added to one file cannot be missed in the other.

## help

### synopsis

Checks that the network plan (network.yml) and the azure config's environments and subscriptions are in sync.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the cross-asset
join of [ADR-AZ-NETWORK-KEYEDBYENVIRONMENT](../../../drs/azure/azure-network-model.md#rule-adr-az-network-keyedbyenvironment) and
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription). Each config
validates its own shape when Get-Config loads it; this gate checks what neither file can check alone: every network environment is a defined
azure.yml environment, and every standard azure.yml environment has a network entry (per-subscription environments are exempt); every
network subscription is a defined azure.yml subscription, every azure.yml subscription has a hub (no customer) or a spoke (a customer), and
a spoke has a workload subnet for each standard environment its subscription serves, and no other. It lists every violation.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-azure-network-plan/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Environments; Subscriptions }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-AzureNetworkPlan
```
