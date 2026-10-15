---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/tests/Invoke-AzCli.L2.Tests.ps1.md
    kind: test-asset
    body_sha: "2da385d71eca"
---

# automation/Catzc.Azure.Cli/tests/Invoke-AzCli.L2.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `if (-not (Get-Command az -ErrorAction Ignore)) {`.

```text
Gate on presence, not the locked version: this thread proves Invoke-AzCli shells out to a working
`az` — it does not assert tools.yml's version lock, so a functional-but-off-version az must still run
(matching the Build-Bicep L2 skeleton). The skip key is the constrained `tool_az_missing` grammar.
```
