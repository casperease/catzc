---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-BILL-REQUIREMFACONDITIONALACCESSPRIVILEGEDACCOUNTS
      - ADR-AZ-WAF-SE-SE05
---

# People reach data through entra groups and only break glass login sits outside tenant policy

This article is one rule:
[ADR-AZ-CAF-BILL-REQUIREMFACONDITIONALACCESSPRIVILEGEDACCOUNTS](../../drs/azure/caf/billing-and-tenant.md#rule-adr-az-caf-bill-requiremfaconditionalaccessprivilegedaccounts)
and [ADR-AZ-WAF-SE-SE05](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se05) merged into one. It holds nothing beyond what those two
rules say.

Multi-factor authentication and Conditional Access are tenant configuration, so requiring them for privileged accounts is not adopted as a
repository rule: the templates route SQL administration through an Entra group, so the tenant's sign-in policies reach it, and only the
break-glass login sits outside them. People reach data through Entra ID groups and services through managed identities, shared-key access is
off, and the one non-identity credential is the break-glass SQL login.
