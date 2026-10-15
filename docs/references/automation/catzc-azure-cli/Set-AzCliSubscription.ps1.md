---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Set-AzCliSubscription.ps1.md
    kind: comment-page
    body_sha: "75ee4954e701"
---

# automation/Catzc.Azure.Cli/Set-AzCliSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`.

```text
Idempotent: skip if already on the requested subscription
-NoAssert: non-zero exit means "not logged in" — falls through to az account set
```

## comment:2

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`.

```text
Idempotent: skip if already on the requested subscription
-NoAssert: non-zero exit means "not logged in" — falls through to az account set
```
