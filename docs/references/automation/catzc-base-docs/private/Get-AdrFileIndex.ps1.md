# docs/references/automation/catzc-base-docs/private/Get-AdrFileIndex.ps1.md

`automation/Catzc.Base.Docs/private/Get-AdrFileIndex.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Enumerates every docs/adr/**/*.md once and keys it by its first folder under docs/adr/ (the domain folder; empty for a file at
the root) and its file name without extension, so a slug shared across domains (one in automation/, one in research/) stays
distinct and a slug repeated within one domain's subfolders shows as two files under one key. FileOf maps a rule set's External
code to its file when exactly one file has its key; a rule set with none or several is a finding of the registry quality gate
(Test-AdrRegistry), so the checks that read rule files skip it.

Private helper for Test-AdrRegistry and Test-AdrEngineNeutrality; not exported.
```
