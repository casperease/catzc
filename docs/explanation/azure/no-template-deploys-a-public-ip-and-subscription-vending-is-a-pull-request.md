---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETCON-COVEREVERYPUBLICIPADDRESSDDOSPROTECTION
      - ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS
---

# No template deploys a public ip and subscription vending is a pull request

This article is one rule:
[ADR-AZ-CAF-NETCON-COVEREVERYPUBLICIPADDRESSDDOSPROTECTION](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-covereverypublicipaddressddosprotection)
and
[ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS](../../drs/azure/caf/resource-organization.md#rule-adr-az-caf-resorg-subscriptionvendingprocess)
merged into one. It holds nothing beyond what those two rules say.

DDoS protection for every public IP address is not adopted, because no template deploys a public IP address; the landing zone's policy keeps
them off network interfaces, and the unused `vm.bicep`, which creates one, is planned to lose it. Subscription vending is partly adopted as
a pull request: an `azure.yml` entry, its range in `network.yml`, and one config per template giving it its workspace, vault, landing zone,
tags and budget.
