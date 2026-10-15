---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/private/Get-NetworkPlanViolations.ps1.md
    kind: comment-page
    body_sha: "72719e9a025c"
    adrs:
      - ADR-AZ-NETWORK#2
      - ADR-AZ-NETWORK#4
      - ADR-AZ-NETWORK#5
---

# automation/Catzc.Azure/private/Get-NetworkPlanViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The cross-asset join of [ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2) and
[ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5), over two already-typed configs.

Environments: every network environment is a defined azure.yml environment (no ghost plan), and every STANDARD
azure.yml environment has a network entry. Per-subscription environments (nsub/psub) are exempt — they carry no
vnet ([ADR-AZ-NETWORK#4](/docs/adr/azure/azure-network-model.md#rule-adr-az-network4)).

Subscriptions: every network subscription is a defined azure.yml subscription (no ghost network), and every
azure.yml subscription has one of the right kind — a hub when it has no customer, a spoke when it has one. A spoke
has exactly one workload subnet per standard environment its subscription serves, named for that environment.
```
