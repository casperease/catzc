# docs/references/automation/catzc-base-writers/Write-CmdletParameterSet.ps1.md

`automation/Catzc.Base.Writers/Write-CmdletParameterSet.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Pass $MyInvocation as the first argument at the top of a function to display
all parameters that were actually bound. Sensitive parameters can be masked
by listing their names in -HiddenKeys.
```
