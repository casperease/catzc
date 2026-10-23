---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-IAM-GOVERNPRIVILEGEDAUTOMATIONLIKEPRIVILEGEDPEOPLE
      - ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS
---

# Every deploy runs through the subscriptions service connection under zero trust

This article is one rule:
[ADR-AZ-CAF-IAM-GOVERNPRIVILEGEDAUTOMATIONLIKEPRIVILEGEDPEOPLE](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-governprivilegedautomationlikeprivilegedpeople)
and [ADR-AZ-CAF-SEC-ZEROTRUSTPLATFORMACCESS](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-zerotrustplatformaccess)
merged into one. It holds nothing beyond what those two rules say.

Every deploy runs through the service connection of its subscription, pinned by `-SubscriptionIdAssertIs`, and the infrastructure CI needs
no Azure identity; separating the landing-zone identity from the workload identity is planned. Access to the platform follows Zero Trust
through Entra ID identities, a service connection per subscription pinned on every deploy, and private endpoints for data.
