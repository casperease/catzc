---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETTOP-ONERESOURCEGROUPPERREGIONHUBRESOURCES
      - ADR-AZ-CAF-MGMT-GROUPWORKLOADRESOURCESSERVICEGROUPS
---

# A hubs resources share one regional group and a workloads resources sit together

This article is one rule:
[ADR-AZ-CAF-NETTOP-ONERESOURCEGROUPPERREGIONHUBRESOURCES](../../drs/azure/caf/network-topology.md#rule-adr-az-caf-nettop-oneresourcegroupperregionhubresources)
and
[ADR-AZ-CAF-MGMT-GROUPWORKLOADRESOURCESSERVICEGROUPS](../../drs/azure/caf/management.md#rule-adr-az-caf-mgmt-groupworkloadresourcesservicegroups)
merged into one. It holds nothing beyond what those two rules say.

Resources that belong together sit together. Each hub's resources are in one resource group of its region, named with the region code
(`nsub-weu-zct-disco-rg`). A workload's resources likewise sit together, one resource group per configuration slot, named by the `workload`
tag, inside one subscription, which is why grouping workload resources in service groups is not adopted.
