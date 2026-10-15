---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Test-AzCliConnected.ps1.md
    kind: reference
    body_sha: "9ad90ffaa0c9"
    adrs: []
---

# automation/Catzc.Azure.Cli/Test-AzCliConnected.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $true when `az account show` reports the subscription and/or tenant passed by argument;
$false otherwise (including not logged in). A pure query — it never throws on a mismatch. Use
Assert-AzCliConnected for the throwing companion. Both share Get-AzCliConnectionState.

Two parameter sets — at least one of subscription / tenant is required:
  Subscription : -SubscriptionId (required) [-TenantId]
  Tenant       : -TenantId (required)
```
