---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-GOV-PREFERBUILTPOLICIES
      - ADR-AZ-CAF-DEVOPS-MANAGEAZUREPOLICYASCODE
---

# The landing zone assigns three built in policies as bicep pinned by definition id

This article is one rule: [ADR-AZ-CAF-GOV-PREFERBUILTPOLICIES](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-preferbuiltpolicies)
and
[ADR-AZ-CAF-DEVOPS-MANAGEAZUREPOLICYASCODE](../../drs/azure/caf/platform-automation-and-devops.md#rule-adr-az-caf-devops-manageazurepolicyascode)
merged into one. It holds nothing beyond what those two rules say.

The landing zone assigns three built-in policies and no custom definition, each pinned by its definition id in `discovery/main.bicep` and
registered in `guids.yml`, so a change of definition is one reviewed change. The assignments are Bicep in `discovery`, pinned by definition
id and deployed by its pipeline, so policy is managed as code.
