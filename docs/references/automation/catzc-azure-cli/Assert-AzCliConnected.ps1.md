---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Assert-AzCliConnected.ps1.md
    kind: comment-page
    body_sha: "289629f58664"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Cli/Assert-AzCliConnected.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing companion to Test-AzCliConnected. Throws a remediation-bearing error when az is not
logged in, or is set to a different subscription / tenant than the ones passed by argument. The
generic, azure.yml-free primitive — the config-aware Assert-AzCliIsConnected takes a subscription
name, resolves its identity from azure.yml, and delegates here. Both Assert/Test share Get-AzCliConnectionState.

Two parameter sets — at least one of subscription / tenant is required:
  Subscription : -SubscriptionId (required) [-TenantId]
  Tenant       : -TenantId (required)
```
