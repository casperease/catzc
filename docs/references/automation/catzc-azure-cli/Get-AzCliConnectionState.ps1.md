---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Get-AzCliConnectionState.ps1.md
    kind: comment-page
    body_sha: "689497677d07"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Cli/Get-AzCliConnectionState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs `az account show` and compares the active session against the identity passed by argument —
a subscription (with optional tenant), or a tenant alone. The generic, azure.yml-free primitive:
the single source of the comparison shared by Test-AzCliConnected (returns a bool) and
Assert-AzCliConnected (throws), so the two cannot drift. The config-aware Assert/Test-AzCliIsConnected
resolve a subscription name from azure.yml and delegate here (subscription set);
a caller that only cares about the directory (e.g. an ADO token) uses the tenant set.

Two parameter sets — at least one of subscription / tenant is required:
  Subscription : -SubscriptionId (required) [-TenantId]
  Tenant       : -TenantId (required)

Returns an ordered dictionary:
  { logged_in, connected, expected_tenant, expected_subscription, actual_tenant, actual_subscription }
`logged_in` is false when `az account show` exits non-zero; `connected` additionally requires every
supplied component (subscription and/or tenant) to match.
```
