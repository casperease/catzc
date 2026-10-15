---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Test-AzureNetworkPlan.ps1.md
    kind: reference
    body_sha: "4afb01d03c60"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-AZ-NETWORK#2
      - ADR-AZ-NETWORK#5
---

# automation/Catzc.Azure/Test-AzureNetworkPlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
cross-asset join of [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2) and
[ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5). Each config validates its own
shape when Get-Config loads it; this gate checks what neither file can check alone: every network environment is a
defined azure.yml environment, and every standard azure.yml environment has a network entry (per-subscription
environments are exempt); every network subscription is a defined azure.yml subscription, every azure.yml
subscription has a hub (no customer) or a spoke (a customer), and a spoke has a workload subnet for each standard
environment its subscription serves, and no other. It lists every violation.
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the result ({ Subject; IssueCount; Issues; ReportPath; Environments; Subscriptions }) instead of throwing on
issues.
```
