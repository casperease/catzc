---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-MGMT-PATCHVIRTUALMACHINESUPDATEMANAGER
      - ADR-AZ-CAF-NETCON-USESTANDARDORPREMIUMBASTIONSKUPRODUCTION
---

# No template deploys a virtual machine so patching and bastion are not adopted

This article is one rule:
[ADR-AZ-CAF-MGMT-PATCHVIRTUALMACHINESUPDATEMANAGER](../../drs/azure/caf/management.md#rule-adr-az-caf-mgmt-patchvirtualmachinesupdatemanager)
and
[ADR-AZ-CAF-NETCON-USESTANDARDORPREMIUMBASTIONSKUPRODUCTION](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-usestandardorpremiumbastionskuproduction)
merged into one. It holds nothing beyond what those two rules say.

Two practices are not adopted for the same reason. Patching virtual machines with Update Manager is not adopted, because no template deploys
a virtual machine, so there is no operating system to patch. Using a Standard or Premium Bastion SKU in production is not adopted, because
with no virtual machine deployed there is nothing for Bastion to reach.
