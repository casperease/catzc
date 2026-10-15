---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
    kind: comment-page
    body_sha: "653359804d3d"
    adrs:
      - ADR-AZ-CLI#1
    links: []
---

# automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The azure.yml-aware companion to the generic Test-AzCliSubscriptionAccessible: it takes
a subscription *name* (a key in azure.yml's subscriptions), resolves it to a subscription id via
Get-AzureSubscription, and delegates the real-ARM-read access check down. Returns $true when the
current login can reach the subscription, $false otherwise (including not logged in). A pure query —
it never throws on a mismatch. Use Assert-AzCliCanAccess for the throwing companion.

"IsConnected" asks whether the session is *set to* the subscription; "CanAccess" asks whether the
current login can *reach* it, independent of which subscription is active.
See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md) and
[ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
```
