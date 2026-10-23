---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-IAM-DEFENDERIDENTITY
      - ADR-AZ-CAF-BILL-STARTCLOUDONLYWHENTHEREISNOIDENTITYESTATE
---

# The repository builds no identity estate so defender for identity is not adopted (ADR-AZ-CAF-IAM-DEFENDERIDENTITY + ADR-AZ-CAF-BILL-STARTCLOUDONLYWHENTHEREISNOIDENTITYESTATE)

This article is one rule: [ADR-AZ-CAF-IAM-DEFENDERIDENTITY](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-defenderidentity)
and
[ADR-AZ-CAF-BILL-STARTCLOUDONLYWHENTHEREISNOIDENTITYESTATE](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-startcloudonlywhenthereisnoidentityestate)
merged into one. It holds nothing beyond what those two rules say.

The repository builds no identity estate; it uses the tenant it is given. That one fact settles two choices. Defender for Identity is not
adopted, because there are no directory servers for its sensors and it is licensed for the tenant. Starting cloud-only is not a choice the
repository makes either, because there is no identity estate of its own to start.
