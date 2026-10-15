# docs/references/automation/catzc-tooling-toolchain/Invoke-Go.ps1.md

`automation/Catzc.Tooling.Toolchain/Invoke-Go.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Asserts that the installed Go matches the locked version in Get-ToolConfig, then runs the executable the check
located (Test-Tool -PassThru: the managed home first, then PATH), so the asserted Go is the one that runs.
```
