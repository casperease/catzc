---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS
      - ADR-AZ-CAF-NETCON-EXPOSENOVIRTUALMACHINEMANAGEMENTPORTINTERNET
---

# Resources carry cost tags and unused vm bicep is planned to lose its public ip

This article is one rule:
[ADR-AZ-CAF-GOV-TAGRESOURCESCOSTANALYSIS](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-tagresourcescostanalysis) and
[ADR-AZ-CAF-NETCON-EXPOSENOVIRTUALMACHINEMANAGEMENTPORTINTERNET](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-exposenovirtualmachinemanagementportinternet)
merged into one. It holds nothing beyond what those two rules say.

Every resource names its paying team in `cost-center` and its workload in `workload`; the resource groups that `Deploy-Bicep` creates for
`foundation` and `expedition` carry no CAF tags, which is planned. Every workload subnet denies inbound internet traffic and the landing
zone's policy keeps public IP addresses off network interfaces, but the unused `vm.bicep` creates one and is planned to lose it.
