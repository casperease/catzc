# automation/Catzc.Azure.Cli/Assert-AzCliConnected.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts the active az CLI session matches a given subscription and/or tenant.

### description

The throwing companion to Test-AzCliConnected. Throws a remediation-bearing error when az is not
logged in, or is set to a different subscription / tenant than the ones passed by argument. The
generic, azure.yml-free primitive — the config-aware Assert-AzCliIsConnected takes a subscription
name, resolves its identity from azure.yml, and delegates here. Both Assert/Test share Get-AzCliConnectionState.

Two parameter sets — at least one of subscription / tenant is required:

```text
Subscription : -SubscriptionId (required) [-TenantId]
Tenant       : -TenantId (required)
```

### parameter SubscriptionId

The subscription GUID the session must be set to.

### parameter TenantId

The tenant GUID the session must be in. Optional alongside a subscription; required on its own.

### example 1

```powershell
Assert-AzCliConnected -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000
```

### example 2

```powershell
Assert-AzCliConnected -TenantId fa0e0000-7e0a-0700-1d00-000000000000
```
