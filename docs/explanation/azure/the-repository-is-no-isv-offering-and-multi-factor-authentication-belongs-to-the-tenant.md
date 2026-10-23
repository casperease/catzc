---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-BILL-READISVLANDINGZONEGUIDANCE
      - ADR-AZ-CAF-IAM-MULTIFACTORAUTHENTICATIONEVERYONEAZURERIGHTS
---

# The repository is no isv offering and multi factor authentication belongs to the tenant

This article is one rule:
[ADR-AZ-CAF-BILL-READISVLANDINGZONEGUIDANCE](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-readisvlandingzoneguidance) and
[ADR-AZ-CAF-IAM-MULTIFACTORAUTHENTICATIONEVERYONEAZURERIGHTS](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-multifactorauthenticationeveryoneazurerights)
merged into one. It holds nothing beyond what those two rules say.

Reading ISV landing-zone guidance is not adopted, because the repository is not an ISV offering; its customers are subscriptions in one
tenant. Multi-factor authentication is not adopted as a repository rule, because it is enforced by the tenant's Conditional Access, not by a
template.
