---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-PRIN-POLICYDRIVENGOVERNANCE
      - ADR-AZ-LZ-THREEBUILTINPOLICIES
---

# Three built in policies are the guardrails and policy enforcement decides their effect

This article is one rule:
[ADR-AZ-CAF-PRIN-POLICYDRIVENGOVERNANCE](../../drs/azure/caf/design-principles.md#rule-adr-az-caf-prin-policydrivengovernance) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../drs/azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) merged into one. It holds nothing
beyond what those two rules say.

Policy-driven governance is partly adopted through three built-in Azure Policy guardrails every landing zone assigns at subscription scope:
allowed locations (its region), a required tag on resources, and no public IP address on a network interface. Whether they enforce or only
audit is the repository-wide `policy_enforcement` setting, read by config address, with its sensible default declared once.
