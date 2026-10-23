---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-DATAMOD-TWOCONFIGLAYERS
      - ADR-AZ-IACKIND-THREEKINDS
---

# Identity and templates are two config layers joined through the configuration tree (ADR-AZ-DATAMOD-TWOCONFIGLAYERS + ADR-AZ-IACKIND-THREEKINDS)

This article is one rule: [ADR-AZ-DATAMOD-TWOCONFIGLAYERS](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-twoconfiglayers) and
[ADR-AZ-IACKIND-THREEKINDS](../../drs/azure/infrastructure-kinds.md#rule-adr-az-iackind-threekinds) merged into one. It holds nothing beyond
what those two rules say.

Two config layers, identity in `azure.yml` and templating in `infrastructure/templates/`, join through the conventional configuration tree:
a config at the configuration root is a shared-platform deployment, a config under a `configuration/<customer>/` subfolder is that
customer's, and the subscription is always resolved from that coordinate. The infrastructure code has three kinds: IaC templates, a folder
holding a deployable `main.bicep` and its `options.yml`, their configuration slots and the layer that joins them.
