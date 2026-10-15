# docs/references/automation/catzc-base-qualitygates/private/Get-CommentScope.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-CommentScope.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one scope Export-Comments, Build-CommentView, Format-Comments and Test-Comments share, so the converter, the
view and the gate can never disagree. It starts from the files Get-LinkScope lists (the tracked files, or the
given -Path, minus every file the content tools leave as written) and keeps a file when its file language is one
comments.yml names, comments.yml maps it to a page, and no comments.yml exclude glob matches it (tests and assets by
default) ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
```
