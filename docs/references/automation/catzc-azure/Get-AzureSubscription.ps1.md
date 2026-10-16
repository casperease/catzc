---
catzc:
  immutable:
    with_body_sha: f694fa908eab
    path: docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md
    folder: docs/references/automation/catzc-azure
    name: get-azure-subscription-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure/Get-AzureSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$customerToken = Get-AzureSubscriptionCustomer $found`, written with `#`.

```text
The subscription's `customer` field may name a customer by its key OR its 2-char shortcode; normalize
to the canonical key so the resolved object is the same whichever form the config used. Empty when the
subscription is not a customer subscription. See [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
```
