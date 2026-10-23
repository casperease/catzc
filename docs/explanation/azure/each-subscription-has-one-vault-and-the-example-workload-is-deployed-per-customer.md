---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-IAM-KEYVAULTPERAPPLICATIONENVIRONMENT
      - ADR-AZ-CAF-BILL-READMULTITENANTSOLUTIONGUIDANCE
---

# Each subscription has one vault and the example workload is deployed per customer

This article is one rule:
[ADR-AZ-CAF-IAM-KEYVAULTPERAPPLICATIONENVIRONMENT](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-keyvaultperapplicationenvironment)
and
[ADR-AZ-CAF-BILL-READMULTITENANTSOLUTIONGUIDANCE](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-readmultitenantsolutionguidance)
merged into one. It holds nothing beyond what those two rules say.

Each subscription has its own vault, deployed by `foundation`, not one per application environment; a secret name per configuration slot is
planned and a vault inside each workload is not adopted. Multitenant solution guidance is not adopted, because the example workload is
deployed per customer subscription, not built as a multitenant application.
