---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Get-AzureCustomers.ps1.md
    kind: reference
    body_sha: "4383d9b35540"
    adrs: []
---

# automation/Catzc.Azure/Get-AzureCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the customer catalogue (customer.yml) via Get-Config and returns its keys — the readable customer
names referenced by customer subscriptions in azure.yml. Returns an empty array when the catalogue is
empty. Customer definitions were split out of azure.yml (see
[ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)).
```
