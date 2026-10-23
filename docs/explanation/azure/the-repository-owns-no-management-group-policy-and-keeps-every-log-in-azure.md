---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-GOV-DEFINEPOLICIESATTOPHIERARCHY
      - ADR-AZ-CAF-MGMT-KEEPRAWLOGSAZURENOTPREMISES
---

# The repository owns no management group policy and keeps every log in azure

This article is one rule:
[ADR-AZ-CAF-GOV-DEFINEPOLICIESATTOPHIERARCHY](../../drs/azure/caf/governance.md#rule-adr-az-caf-gov-definepoliciesattophierarchy) and
[ADR-AZ-CAF-MGMT-KEEPRAWLOGSAZURENOTPREMISES](../../drs/azure/caf/management.md#rule-adr-az-caf-mgmt-keeprawlogsazurenotpremises) merged
into one. It holds nothing beyond what those two rules say.

Two adoptions are declined for the same reason of scope. Defining policies at the top of the hierarchy is not adopted, because the
repository owns no management group and defines no policy of its own; the built-in definitions it assigns exist in every tenant. Keeping raw
logs in Azure rather than on premises is not adopted as a choice either, because there is no on-premises monitoring system to forward to, so
every log stays in Azure.
