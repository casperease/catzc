---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-MGMT-AUDITGUESTCONFIGURATIONDRIFTBYPOLICY
      - ADR-AZ-CAF-IAM-KEEPCOREAPPLICATIONSNEARREPLICASETS
---

# No template deploys a virtual machine or a managed directory so two practices are declined

This article is one rule:
[ADR-AZ-CAF-MGMT-AUDITGUESTCONFIGURATIONDRIFTBYPOLICY](../../drs/azure/caf/management.md#rule-adr-az-caf-mgmt-auditguestconfigurationdriftbypolicy)
and
[ADR-AZ-CAF-IAM-KEEPCOREAPPLICATIONSNEARREPLICASETS](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-keepcoreapplicationsnearreplicasets)
merged into one. It holds nothing beyond what those two rules say.

Auditing guest-configuration drift by policy is not adopted, because no template deploys a virtual machine, so there is no in-guest
configuration to audit. Placing core applications near replica sets is not adopted, because no template deploys a managed directory. Both
decisions follow from what the templates deploy.
