---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Set-CurrentAzSubscription.ps1.md
    kind: comment-page
    body_sha: d1accdf26d72
---

# automation/Catzc.Azure.Cli/Set-CurrentAzSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Thin wrapper over `az account set --subscription` (via Invoke-AzCli). This mutates the CLI context, so
it is a loud action call (not silenced). Throws with remediation if the subscription can't be selected
(wrong ID, or the identity lacks access).

Unlike Assert-AzCliConnected, which only asserts the session is already on an expected subscription,
this deliberately switches it. Pairs with Get-CurrentAzSubscription for save / switch / restore.
```
