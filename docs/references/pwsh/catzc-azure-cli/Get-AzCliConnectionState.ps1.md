# pwsh/Azure.Cli/Get-AzCliConnectionState.ps1

The function that compares the active az session with an expected subscription and/or tenant and returns the verdict with both sides.
It is the one place the comparison is made, shared by the connected query and the connected assertion so the two cannot drift.

## help

### synopsis

Returns the az CLI session's connection state relative to a given subscription and/or tenant.

### description

Runs `az account show` and compares the active session against the identity passed by argument — a subscription (with optional tenant), or a
tenant alone. The generic, azure.yml-free primitive: the single source of the comparison shared by Test-AzCliConnected (returns a bool) and
Assert-AzCliConnected (throws), so the two cannot drift. The config-aware Assert/Test-AzCliIsConnected resolve a subscription name from
azure.yml and delegate here (subscription set); a caller that only cares about the directory (e.g. an ADO token) uses the tenant set.

Two parameter sets — at least one of subscription / tenant is required:

```text
Subscription : -SubscriptionId (required) [-TenantId]
Tenant       : -TenantId (required)
```

Returns an ordered dictionary:

```text
{ logged_in, connected, expected_tenant, expected_subscription, actual_tenant, actual_subscription }
```

`logged_in` is false when `az account show` exits non-zero; `connected` additionally requires every supplied component (subscription and/or
tenant) to match.

### parameter `SubscriptionId`

The subscription GUID the session must be set to.

### parameter `TenantId`

The tenant GUID the session must be in. Optional alongside a subscription; required on its own.

### example 1

```powershell
(Get-AzCliConnectionState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).connected
```

### example 2

```powershell
(Get-AzCliConnectionState -TenantId fa0e0000-7e0a-0700-1d00-000000000000).connected
```
