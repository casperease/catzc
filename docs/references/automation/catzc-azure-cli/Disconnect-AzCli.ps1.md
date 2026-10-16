---
catzc:
  immutable:
    with_body_sha: "2ef2e941d69b"
    path: docs/references/automation/catzc-azure-cli/Disconnect-AzCli.ps1.md
    folder: docs/references/automation/catzc-azure-cli
    name: disconnect-az-cli-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Cli/Disconnect-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`, written with `#`.

```text
Idempotent: skip if not logged in
-NoAssert: non-zero exit means "not logged in" — an expected state, not an error
```
