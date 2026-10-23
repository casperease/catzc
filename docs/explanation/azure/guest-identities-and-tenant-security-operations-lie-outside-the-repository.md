---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-IAM-GUESTPARTNERACCESS
      - ADR-AZ-CAF-BILL-FOLLOWENTRASECURITYOPERATIONSGUIDE
---

# Guest identities and tenant security operations lie outside the repository

This article is one rule:
[ADR-AZ-CAF-IAM-GUESTPARTNERACCESS](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-guestpartneraccess) and
[ADR-AZ-CAF-BILL-FOLLOWENTRASECURITYOPERATIONSGUIDE](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-followentrasecurityoperationsguide)
merged into one. It holds nothing beyond what those two rules say.

A choice of guest and partner identity is not adopted, because no workload has users from outside the tenant. Following the Entra security
operations guide is not adopted, because security operations for the tenant are outside the repository. Both are left to the tenant.
