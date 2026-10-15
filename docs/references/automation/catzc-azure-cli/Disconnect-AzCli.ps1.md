---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Disconnect-AzCli.ps1.md
    kind: reference
    body_sha: d7084debd726
    adrs: []
---

# automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`.

```text
Idempotent: skip if not logged in
-NoAssert: non-zero exit means "not logged in" — an expected state, not an error
```
