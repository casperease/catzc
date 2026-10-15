---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/configs/customer.yml.md
    kind: comment-page
    body_sha: "41877f8bdbbe"
    adrs: []
    links: []
---

# automation/Catzc.Azure/configs/customer.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `customers:`.

```text
Customer catalogue — the customers this repo can deploy for. Split out of azure.yml (see
[ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)). Loaded by Get-Config -Config customer; validated by
the CustomerConfig type.

A subscription in azure.yml binds to a customer by naming it in its `customer` field — by EITHER the
readable key (apex) OR the 2-char shortcode (ap); both resolve to the same customer. The key is the
customer-segment of relaxed (generous) resource names and the config subfolder; the 2-char `shortcode`
(unique) is the customer-segment of the restricted kv/storage/vm patterns — the same name/shortcode
split as environments (see [ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). `details` is a free-text label.

WHICH of these customers are actually enabled for deployment is the `have_customers` variant in
variants.yml (false | all | [names]) — this file is only the catalogue of who they are. Optional — a
repo with no customers omits the file (Get-AzureCustomers returns @()).
```
