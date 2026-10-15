---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
    kind: comment-page
    body_sha: "9fb5adcf8f9c"
---

# automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$probe = Invoke-AzCli "account list-locations --subscription $SubscriptionId...`.

```text
A REAL, read-only ARM call scoped to the subscription. Exit zero proves the current login can
reach it via `--subscription`, whether or not it is the active subscription.
```

## comment:5

Above `$session = Invoke-AzCli 'account show -o none' -PassThru -NoAssert -Silent`.

```text
The probe failed. Distinguish "not logged in" from "logged in but cannot reach this subscription"
with a local read (only on the error path) so the error names the right fix.
```
