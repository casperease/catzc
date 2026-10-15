---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
    kind: comment-page
    body_sha: b1b33866f568
    adrs:
      - ADR-AZ-CLI#1
---

# automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The access counterpart to Get-AzCliConnectionState. Where the connection-state primitive asks
"is this subscription the *active* one?" (a local `az account show` read), this primitive asks
"can my current login *reach* this subscription right now?" — independent of which subscription is
active. That distinction matters because az CLI commands accept `--subscription <id>`: a function
can operate against a subscription it is not "set to", so before it does, it should assert the
later call will succeed.

To prove a later real call will work, this makes a REAL, read-only ARM call scoped to the
subscription (`az account list-locations --subscription <id>`) — not a local profile read.
Succeeding proves the current login holds a valid token with access to that subscription. A local
`az account show` would not: it only reports the on-disk profile and never touches ARM, so it
cannot tell an expired token or a revoked role from a working one.

The generic, azure.yml-free primitive — the single source of the check shared by
Test-AzCliSubscriptionAccessible (returns a bool) and Assert-AzCliSubscriptionAccessible (throws),
so the two cannot drift. See
[ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).

Returns an ordered dictionary:
  { logged_in, accessible, subscription, detail }
`accessible` is true only when the scoped ARM probe exits zero. On failure, `logged_in`
distinguishes "not logged in at all" from "logged in but no access to this subscription" (a local
`az account show`, run only on the error path) so callers can name the right remediation.
```

## comment:2

Above `$probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId...`.

```text
A REAL, read-only ARM call scoped to the subscription. Exit zero proves the current login can
reach it via `--subscription`, whether or not it is the active subscription.
```

## comment:3

Above `$session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent`.

```text
The probe failed. Distinguish "not logged in" from "logged in but cannot reach this subscription"
with a local read (only on the error path) so the error names the right fix.
```
