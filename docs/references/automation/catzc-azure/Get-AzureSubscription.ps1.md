---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md
    kind: comment-page
    body_sha: "0613c7e96b34"
    adrs:
      - ADR-AZ-DATAMOD#4
---

# automation/Catzc.Azure/Get-AzureSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads configs/azure.yml via Get-Config and looks up the subscription by name (a key in
`subscriptions`) — the by-name identity lookup the resolved configuration coordinates and the session
reverse lookup (Get-AzCliSessionSubscription) build on; there is no (environment, group, customer)
join here. The matching tenant is looked up by name and embedded. A
subscription MAY carry a `customer`, named by its key OR its 2-char shortcode (a customer in
customer.yml); it is resolved to the canonical key and included (and renders into the resource names of
anything deployed there). See [ADR-AZ-DATAMOD#4](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod4) and
[ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
```

## comment:2

Above `$customerToken = Get-AzureSubscriptionCustomer $found`.

```text
The subscription's `customer` field may name a customer by its key OR its 2-char shortcode; normalize
to the canonical key so the resolved object is the same whichever form the config used. Empty when the
subscription is not a customer subscription. See [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
```

## comment:3

Above `$customerToken = Get-AzureSubscriptionCustomer $found`.

```text
The subscription's `customer` field may name a customer by its key OR its 2-char shortcode; normalize
to the canonical key so the resolved object is the same whichever form the config used. Empty when the
subscription is not a customer subscription. See [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
```
