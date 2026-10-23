---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-LZ-LANDINGZONE
      - ADR-AZ-CAF-PRIN-APPLICATIONCENTRICSERVICEMODEL
---

# A landing zone is deployed once per subscription and a workload lands in it

This article is one rule: [ADR-AZ-LZ-LANDINGZONE](../../drs/azure/landing-zones.md#rule-adr-az-lz-landingzone) and
[ADR-AZ-CAF-PRIN-APPLICATIONCENTRICSERVICEMODEL](../../drs/azure/caf/design-principles.md#rule-adr-az-caf-prin-applicationcentricservicemodel)
merged into one. It holds nothing beyond what those two rules say.

A landing zone is the network, the guardrails and the cost control a workload lands in, deployed once per subscription at subscription scope
by the `discovery` template, the Cloud Adoption Framework application landing zone; its boundary is the subscription. A workload is a
template that lands in the landing zone of its subscription and owns none of it, segmented by customer subscription and environment class,
not by a management group archetype.
