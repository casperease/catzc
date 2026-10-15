---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md
    kind: comment-page
    body_sha: "5c4fe675c1cc"
---

# automation/Catzc.Azure/Get-AzureSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$customerToken = Get-AzureSubscriptionCustomer $found`.

```text
The subscription's `customer` field may name a customer by its key OR its 2-char shortcode; normalize
to the canonical key so the resolved object is the same whichever form the config used. Empty when the
subscription is not a customer subscription. See [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
```
