---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETTOP-ONERESOURCEGROUPPERREGIONHUBRESOURCES
      - ADR-AZ-CAF-RESORG-RESOURCEGROUPRESOURCESREGION
---

# A resource group lives in its regions and a hubs resources share one per region

This article is one rule:
[ADR-AZ-CAF-NETTOP-ONERESOURCEGROUPPERREGIONHUBRESOURCES](../../drs/azure/caf/network-topology.md#rule-adr-az-caf-nettop-oneresourcegroupperregionhubresources)
and
[ADR-AZ-CAF-RESORG-RESOURCEGROUPRESOURCESREGION](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-resourcegroupresourcesregion)
merged into one. It holds nothing beyond what those two rules say.

A resource group is created in its environment's region and the resources in it default to the resource group's region. Each hub's resources
sit in one resource group of its region, named with the region code, for example `nsub-weu-zct-disco-rg`.
