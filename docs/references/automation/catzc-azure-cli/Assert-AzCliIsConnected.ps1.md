---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md
    kind: reference
    body_sha: "54143d294af8"
    adrs: []
---

# automation/Catzc.Azure.Cli/Assert-AzCliIsConnected.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing companion to Test-AzCliIsConnected (which returns a bool). Throws a remediation-bearing
error when az is not logged in, or is logged into the wrong tenant / subscription. A connection is
subscription-scoped, so the input is the subscription name: it resolves the subscription + tenant
from azure.yml (Get-AzureSubscription) and delegates the check to the generic Get-AzCliConnectionState.
See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```
