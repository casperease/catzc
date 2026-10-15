# docs/references/automation/catzc-base-variants/Test-AdoNaming.ps1.md

`automation/Catzc.Base.Variants/Test-AdoNaming.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A predicate over the `ado_naming` repo-wide variant (see Get-AdoNaming). Pass exactly one of -Standard
or -Classic; returns $true when the repo's order matches. A guard callable anywhere above the Config
layer; use Assert-AdoNaming to fail instead of branch.
```
