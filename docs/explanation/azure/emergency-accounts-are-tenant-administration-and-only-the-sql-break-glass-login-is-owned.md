---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-BILL-PLANEMERGENCYACCESSACCOUNTS
      - ADR-AZ-CAF-IAM-EMERGENCYACCESSACCOUNTS
---

# Emergency accounts are tenant administration and only the sql break glass login is owned (ADR-AZ-CAF-BILL-PLANEMERGENCYACCESSACCOUNTS + ADR-AZ-CAF-IAM-EMERGENCYACCESSACCOUNTS)

This article is one rule:
[ADR-AZ-CAF-BILL-PLANEMERGENCYACCESSACCOUNTS](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-planemergencyaccessaccounts)
and [ADR-AZ-CAF-IAM-EMERGENCYACCESSACCOUNTS](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-emergencyaccessaccounts) merged
into one. It holds nothing beyond what those two rules say.

Tenant emergency-access accounts are not adopted, because emergency accounts are tenant administration. The idea is carried one level down,
at the level the repository owns: each SQL server has a break-glass SQL login that keeps it reachable, and monitoring its use is planned.
