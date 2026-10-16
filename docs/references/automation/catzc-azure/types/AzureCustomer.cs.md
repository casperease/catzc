---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/AzureCustomer.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "65a0c8ffdf4d"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Azure/types/AzureCustomer.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One customer of the catalogue (configs/customer.yml, [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)):
a readable key (the customers-map key — the customer-segment of relaxed resource names and the configuration
subfolder name), a 2-char shortcode (the customer-segment of the restricted kv/storage/vm patterns), and optional
free-text details. Mirrors a `customers` entry (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `key` is the map key.

Constructing an instance validates the entry, collecting every violation into one ArgumentException: the key is
2+ lowercase alphanumeric with a leading letter, the shortcode is exactly 2 lowercase letters, and the entry
carries no key but shortcode and details. Catalogue-wide rules (shortcode uniqueness, key ≠ any shortcode) are
CustomerConfig's.
```
