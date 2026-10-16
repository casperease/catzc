---
catzc:
  immutable:
    with_body_sha: "901ddbb93e94"
    path: docs/references/automation/catzc-azure-cli/Set-AzCliSubscription.ps1.md
    folder: docs/references/automation/catzc-azure-cli
    name: set-az-cli-subscription-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Cli/Set-AzCliSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`, written with `#`.

```text
Idempotent: skip if already on the requested subscription
-NoAssert: non-zero exit means "not logged in" — falls through to az account set
```
