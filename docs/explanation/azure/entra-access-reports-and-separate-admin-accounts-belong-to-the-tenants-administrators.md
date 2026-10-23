---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-SEC-ACCESSAUDITREPORTSFROMENTRAID
      - ADR-AZ-CAF-IAM-SEPARATEADMINISTRATIVEFROMEVERYDAYACCOUNTS
---

# Entra access reports and separate admin accounts belong to the tenants administrators

This article is one rule:
[ADR-AZ-CAF-SEC-ACCESSAUDITREPORTSFROMENTRAID](../../drs/azure/caf/landing-zone-security.md#rule-adr-az-caf-sec-accessauditreportsfromentraid)
and
[ADR-AZ-CAF-IAM-SEPARATEADMINISTRATIVEFROMEVERYDAYACCOUNTS](../../drs/azure/caf/identity-and-access.md#rule-adr-az-caf-iam-separateadministrativefromeverydayaccounts)
merged into one. It holds nothing beyond what those two rules say.

Access audit reports from Entra ID are not adopted, because the directory and its reports belong to the tenant's administrators. Separate
administrative accounts are not adopted, because accounts are objects of the tenant's directory. The repository leaves both to those who run
the directory.
