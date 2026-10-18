# pwsh/Catzc.Azure/Test-AzureNetworkPlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: the network plan (network.yml) and the azure config's environments and subscriptions are in sync.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the cross-asset join of
[ADR-AZ-NETWORK#2](../../../adr/azure/azure-network-model.md#rule-adr-az-network2) and
[ADR-AZ-NETWORK#5](../../../adr/azure/azure-network-model.md#rule-adr-az-network5). Each config validates its own shape when Get-Config
loads it; this gate checks what neither file can check alone: every network environment is a defined azure.yml environment, and every
standard azure.yml environment has a network entry (per-subscription environments are exempt); every network subscription is a defined
azure.yml subscription, every azure.yml subscription has a hub (no customer) or a spoke (a customer), and a spoke has a workload subnet for
each standard environment its subscription serves, and no other. It lists every violation.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-azure-network-plan/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Environments; Subscriptions }) instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-AzureNetworkPlan
```
