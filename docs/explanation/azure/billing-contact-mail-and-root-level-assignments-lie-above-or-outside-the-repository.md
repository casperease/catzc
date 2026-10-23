---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-BILL-ACTMCANOTIFICATIONMAIL
      - ADR-AZ-CAF-GOV-KEEPROOTLEVELASSIGNMENTSFEW
---

# Billing contact mail and root level assignments lie above or outside the repository

This article is one rule:
[ADR-AZ-CAF-BILL-ACTMCANOTIFICATIONMAIL](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-actmcanotificationmail) and
[ADR-AZ-CAF-GOV-KEEPROOTLEVELASSIGNMENTSFEW](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-keeprootlevelassignmentsfew) merged into
one. It holds nothing beyond what those two rules say.

Notification mail for the contact mailbox is not adopted as a repository choice, because the mailbox belongs to billing administration above
the repository. Keeping root-level assignments few is not adopted, because the repository makes no assignment above a subscription; the
subscription assignments carry no exclusions to manage.
