# automation/Catzc.Base.QualityGates/private/Format-FunctionHelpText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Sections move and citations are ordered, but no prose is written: text a person authored is left as it is.
[ADR-REPO-HELP#1](/docs/adr/repository/function-help.md#rule-adr-repo-help1),
[ADR-REPO-HELP#2](/docs/adr/repository/function-help.md#rule-adr-repo-help2),
[ADR-REPO-HELP#3](/docs/adr/repository/function-help.md#rule-adr-repo-help3),
[ADR-REPO-HELP#4](/docs/adr/repository/function-help.md#rule-adr-repo-help4)
```
