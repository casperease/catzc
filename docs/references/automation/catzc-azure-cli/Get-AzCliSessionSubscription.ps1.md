# automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the az session's active subscription to its declared azure.yml identity.

### description

The reverse lookup that makes the session the deploy-target selector: reads the active subscription
(Get-CurrentAzSubscription — in a pipeline, exactly what the service connection logged into), finds
the azure.yml subscription with that GUID, and returns the declared identity. Read-only — it never
logs in or switches context (verify is not connect,
[ADR-AZ-SESSION](../../../adr/azure/az-session-verification.md));
config defines correct, so a session pointed at a subscription azure.yml does not declare is an
error, not a fallback.

### outputs

An ordered dictionary: @{ name; id; customer; tenant } — `name` is the azure.yml subscription key,
`customer` the canonical customer key ('' for a non-customer subscription), `tenant` the resolved
tenant object.

### example 1

```powershell
(Get-AzCliSessionSubscription).name      # -> apex_nonprod  (whatever the session is set to)
```

### example 2

```powershell
(Get-AzCliSessionSubscription).customer  # -> apex  ('' for a non-customer subscription)
```
