# pwsh/Azure.Cli/Get-AzCliSubscriptionAccessState.ps1

The function that reports whether the current az login can reach a subscription given by GUID, whether or not it is the active one. It is
the one place the check is made, shared by the accessible query and the accessible assertion.

## help

### synopsis

Returns whether the current az CLI login can actually reach a given subscription.

### description

The access counterpart to Get-AzCliConnectionState. Where the connection-state primitive asks "is this subscription the _active_ one?" (a
local `az account show` read), this primitive asks "can my current login _reach_ this subscription right now?" — independent of which
subscription is active. That distinction matters because az CLI commands accept `--subscription <id>`: a function can operate against a
subscription it is not "set to", so before it does, it should assert the later call will succeed.

To prove a later real call will work, this makes a REAL, read-only ARM call scoped to the subscription
(`az account list-locations --subscription <id>`) — not a local profile read. Succeeding proves the current login holds a valid token with
access to that subscription. A local `az account show` would not: it only reports the on-disk profile and never touches ARM, so it cannot
tell an expired token or a revoked role from a working one.

The generic, azure.yml-free primitive — the single source of the check shared by Test-AzCliSubscriptionAccessible (returns a bool) and
Assert-AzCliSubscriptionAccessible (throws), so the two cannot drift. See
[ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

Returns an ordered dictionary:

```text
{ logged_in, accessible, subscription, detail }
```

`accessible` is true only when the scoped ARM probe exits zero. On failure, `logged_in` distinguishes "not logged in at all" from "logged in
but no access to this subscription" (a local `az account show`, run only on the error path) so callers can name the right remediation.

### parameter `SubscriptionId`

The subscription GUID the current login must be able to reach.

### example 1

```powershell
(Get-AzCliSubscriptionAccessState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).accessible
```

## The probe

The check is a real, read-only ARM call scoped to the subscription. A zero exit proves the current login can reach the subscription
through `--subscription`, whether or not it is the active one.

## After a failed probe

On failure the function reads the local session once (`az account show`) to tell "not logged in" from "logged in but cannot reach this
subscription", so the error names the right fix. That read runs only on the error path.
