---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
    kind: reference
    body_sha: "924f929a9ad4"
    adrs:
      - ADR-AZ-CLI#1
---

# automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The azure.yml-aware companion to the generic Assert-AzCliSubscriptionAccessible: it
takes a subscription *name* (a key in azure.yml's subscriptions), resolves it to a subscription id
via Get-AzureSubscription, and delegates the real-ARM-read access check down. Drop it at the top of
a function to fail fast before it calls az against that subscription — whether the subscription is
the active one or supplied via `--subscription <id>`.

This is to access what Assert-AzCliIsConnected is to active-context: same name resolution, different
question. "IsConnected" asks whether the session is *set to* the subscription; "CanAccess" asks
whether the current login can *reach* it, independent of which subscription is active.
See [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md) and
[ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
```
