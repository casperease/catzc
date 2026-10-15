# docs/references/automation/catzc-base-qualitygates/private/Get-TestExcludeTag.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-TestExcludeTag.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Excludes every tier tag outside [MinLevel, MaxLevel] and, when -Category is Logic or Integrity, the OTHER
category's tag. ExcludeTag values are lowercase to match the test files' actual tags ('logic'/'integrity');
tier tags are [Catzc.Base.Timeouts.TestTiers]::Names ('L0'..'L4'). A mixed file's per-Context category tags
filter correctly because ExcludeTag matches an item's own tag.
```
