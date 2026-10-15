---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Test-AzCliIsConnected.ps1.md
    kind: reference
    body_sha: "117f06bc10b0"
    adrs: []
---

# automation/Catzc.Azure.Cli/Test-AzCliIsConnected.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $true when `az account show` reports the tenant + subscription that azure.yml resolves for
the named subscription (via Get-AzureSubscription), $false otherwise (including not-logged-in). A pure
query — it never throws on a mismatch. Use Assert-AzCliIsConnected for the throwing companion (with a
remediation message). A connection is subscription-scoped, so the input is the subscription name;
delegates to the generic Test-AzCliConnected.
```
