---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY
      - ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD
---

# Azure records are schema validated and the customer reference is checked elsewhere

This article is one rule: [ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)
and [ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)
merged into one. It holds nothing beyond what those two rules say.

Per-record shape is schema-validated and cross-record integrity is owned by the `AzureConfig` config type. The subscription to customer
reference is not validated when `azure.yml` loads, since cross-checking it there would make every `azure.yml` read also read `customer.yml`;
it is enforced two other ways instead, one of them a shipped-asset integrity test.
