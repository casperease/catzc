---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md
    kind: comment-page
    body_sha: "7c3f710b5082"
    adrs:
      - ADR-AZ-CLI#1
---

# automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $true when a real, read-only ARM call scoped to the subscription succeeds with the current
login; $false otherwise (including not logged in). A pure query — it never throws on a mismatch.
Use Assert-AzCliSubscriptionAccessible for the throwing companion. Both share
Get-AzCliSubscriptionAccessState.

Unlike Test-AzCliConnected (which asks "is this subscription the active one?"), this asks "can my
current login reach this subscription?", independent of the active context — the question to ask
before a call that supplies `--subscription <id>`.
See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
```
