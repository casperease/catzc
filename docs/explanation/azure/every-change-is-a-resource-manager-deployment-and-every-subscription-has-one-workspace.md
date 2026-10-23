---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-PRIN-SINGLECONTROLMANAGEMENTPLANE
      - ADR-AZ-WAF-OE-OE07
---

# Every change is a resource manager deployment and every subscription has one workspace

This article is one rule:
[ADR-AZ-CAF-PRIN-SINGLECONTROLMANAGEMENTPLANE](../../drs/azure/caf/design-principles.md#rule-adr-az-caf-prin-singlecontrolmanagementplane)
and [ADR-AZ-WAF-OE-OE07](../../drs/azure/waf/operational-excellence.md#rule-adr-az-waf-oe-oe07) merged into one. It holds nothing beyond
what those two rules say.

Every change is an Azure Resource Manager deployment through Bicep and the az CLI, with catzc a thin command line over it and never a portal
in front of it. Monitoring goes to one Log Analytics workspace per subscription, `foundation`'s, not to one central workspace: every
subscription has one, and every resource that emits logs or metrics sends them there through a diagnostic setting its own template deploys,
with alerts on health changes joining them.
