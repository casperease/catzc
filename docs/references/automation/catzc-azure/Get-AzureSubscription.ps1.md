---
catzc:
  immutable:
    with_body_sha: f694fa908eab
    repo_status: locked
    path: docs/references/automation/catzc-azure/Get-AzureSubscription.ps1.md
    folder: docs/references/automation/catzc-azure
    name: get-azure-subscription-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure/Get-AzureSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the resolved Azure subscription identity (id + tenant [+ customer]) for a named subscription.

### description

Reads configs/azure.yml via Get-Config and looks up the subscription by name (a key in
`subscriptions`) — the by-name identity lookup the resolved configuration coordinates and the session
reverse lookup (Get-AzCliSessionSubscription) build on; there is no (environment, group, customer)
join here. The matching tenant is looked up by name and embedded. A
subscription MAY carry a `customer`, named by its key OR its 2-char shortcode (a customer in
customer.yml); it is resolved to the canonical key and included (and renders into the resource names of
anything deployed there). See [ADR-AZ-DATAMOD#4](../../../adr/azure/azure-data-model.md#rule-adr-az-datamod4) and
[ADR-AZ-CUSTOMER](../../../adr/azure/azure-customer-model.md).

### parameter Subscription

Subscription name — a key in azure.yml's `subscriptions`.

### example 1

```powershell
$sub = Get-AzureSubscription shared_nonprod
$sub.id
$sub.tenant.id
```

### example 2

```powershell
(Get-AzureSubscription apex_nonprod).customer   # -> apex
```

## comment:1

Above `$customerToken = Get-AzureSubscriptionCustomer $found`, written with `#`.

```text
The subscription's `customer` field may name a customer by its key OR its 2-char shortcode; normalize
to the canonical key so the resolved object is the same whichever form the config used. Empty when the
subscription is not a customer subscription. See [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md).
```
