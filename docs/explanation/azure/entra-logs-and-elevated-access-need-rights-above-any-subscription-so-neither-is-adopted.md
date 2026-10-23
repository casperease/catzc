---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-IAM-ENTRALOGSAZUREMONITOR
      - ADR-AZ-CAF-BILL-LEAVEELEVATEDACCESSAZURERESOURCESOFF
---

# Entra logs and elevated access need rights above any subscription so neither is adopted

This article is one rule:
[ADR-AZ-CAF-IAM-ENTRALOGSAZUREMONITOR](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-entralogsazuremonitor) and
[ADR-AZ-CAF-BILL-LEAVEELEVATEDACCESSAZURERESOURCESOFF](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-leaveelevatedaccessazureresourcesoff)
merged into one. It holds nothing beyond what those two rules say.

Streaming Entra ID logs to a workspace is not adopted, because a tenant diagnostic setting needs rights above any subscription. Leaving
elevated access to Azure resources off is not adopted either, because the elevation setting belongs to the tenant's Global Administrators;
the repository needs no right above a subscription.
