---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-SEC-SECURITYREQUIREMENTSALIGNEDAZUREROADMAPS
      - ADR-AZ-CAF-IAM-TRACKNEWROLEDEFINITIONS
---

# Roadmap and role definition tracking are not processes of their own

This article is one rule:
[ADR-AZ-CAF-SEC-SECURITYREQUIREMENTSALIGNEDAZUREROADMAPS](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-securityrequirementsalignedazureroadmaps)
and [ADR-AZ-CAF-IAM-TRACKNEWROLEDEFINITIONS](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-tracknewroledefinitions) merged
into one. It holds nothing beyond what those two rules say.

Tracking Azure roadmaps is not adopted as a process of its own, and neither is tracking new role definitions: each CAF and WAF record
carries its retrieval date and is revisited when the vendor guidance changes.
