---
catzc:
  immutable:
    with_body_sha: "1a55addf289e"
    repo_status: locked
    path: docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
    folder: docs/references/automation/catzc-azure-cli
    name: get-az-cli-subscription-access-state-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
[ADR-AZ-CLI#1](../../../adr/azure/prefer-az-cli.md#rule-adr-az-cli1).

Returns an ordered dictionary:

```text
{ logged_in, accessible, subscription, detail }
```

`accessible` is true only when the scoped ARM probe exits zero. On failure, `logged_in` distinguishes "not logged in at all" from "logged in
but no access to this subscription" (a local `az account show`, run only on the error path) so callers can name the right remediation.

### parameter SubscriptionId

The subscription GUID the current login must be able to reach.

### example 1

```powershell
(Get-AzCliSubscriptionAccessState -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000).accessible
```

## comment:1

Above `$probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId...`, written with `#`.

```text
A REAL, read-only ARM call scoped to the subscription. Exit zero proves the current login can
reach it via `--subscription`, whether or not it is the active subscription.
```

## comment:2

Above `$session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent`, written with `#`.

```text
The probe failed. Distinguish "not logged in" from "logged in but cannot reach this subscription"
with a local read (only on the error path) so the error names the right fix.
```
