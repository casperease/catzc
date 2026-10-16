---
catzc:
  immutable:
    with_body_sha: "1a55addf289e"
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
