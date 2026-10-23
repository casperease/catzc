---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD
      - ADR-AZ-SESSION-REVERSELOOKUP
---

# The customer reference is checked by tests and a reverse lookup names the session

This article is one rule:
[ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload) and
[ADR-AZ-SESSION-REVERSELOOKUP](../../drs/azure/az-session-verification.md#rule-adr-az-session-reverselookup) merged into one. It holds
nothing beyond what those two rules say.

The subscription to customer reference is not validated when `azure.yml` loads, since that would make every read also read `customer.yml`.
The reverse lookup adds a layer: `Get-AzCliSessionSubscription` reads the session's active subscription and resolves its GUID to the
declared `azure.yml` identity, name, customer and tenant, throwing when the session targets a subscription `azure.yml` does not declare.
