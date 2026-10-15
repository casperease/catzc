# automation/Catzc.Base.QualityGates/private/Move-FunctionHelpCitation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Only a parenthesised citation is moved out of the synopsis and only a line made of citations out of the description, never prose.
[ADR-REPO-HELP#2](/docs/adr/repository/function-help.md#rule-adr-repo-help2)
```
