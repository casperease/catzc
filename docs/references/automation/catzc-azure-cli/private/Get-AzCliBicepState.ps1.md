---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/private/Get-AzCliBicepState.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a33ead7351f2
    adrs:
      - ADR-AUTO-PRELOG#5
---

# automation/Catzc.Azure.Cli/private/Get-AzCliBicepState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent`, written with `#`.

```text
-Silent: a plumbing probe whose output we capture via -PassThru and parse below, so the
"Bicep CLI version X" line should not echo to the console on every build. See log ADR rule
[ADR-AUTO-PRELOG#5](/docs/adr/automation/log-before-invoke.md#rule-adr-auto-prelog5).
```
