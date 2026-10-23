---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-SEC-NOVAULTSHAREDBETWEENAPPLICATIONSORENVIRONMENTS
      - ADR-AZ-CAF-IAM-SEPARATESECURITYCONFIGURATIONPERENVIRONMENT
---

# Vaults and service connections are per tier and the environments of a tier share them

This article is one rule:
[ADR-AZ-CAF-SEC-NOVAULTSHAREDBETWEENAPPLICATIONSORENVIRONMENTS](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-novaultsharedbetweenapplicationsorenvironments)
and
[ADR-AZ-CAF-IAM-SEPARATESECURITYCONFIGURATIONPERENVIRONMENT](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-separatesecurityconfigurationperenvironment)
merged into one. It holds nothing beyond what those two rules say.

Vaults are separate per customer and per tier, but the environments of one tier share their tier's vault and the same secret name; a secret
name per configuration slot is planned. Managed identities are per resource and vaults and service connections per tier, the environments of
one tier sharing their service connection and their vault secret, and every environment sharing the SQL administrator group; separating them
is planned.
