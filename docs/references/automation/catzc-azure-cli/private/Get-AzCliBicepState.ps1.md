---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/private/Get-AzCliBicepState.ps1.md
    kind: comment-page
    body_sha: dc97cb2ad255
    adrs:
      - ADR-AUTO-PRELOG#5
---

# automation/Catzc.Azure.Cli/private/Get-AzCliBicepState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent`.

```text
-Silent: a plumbing probe whose output we capture via -PassThru and parse below, so the
"Bicep CLI version X" line should not echo to the console on every build. See log ADR rule
[ADR-AUTO-PRELOG#5](/docs/adr/automation/log-before-invoke.md#rule-adr-auto-prelog5).
```
