# docs/references/automation/catzc-base-markdownmeta/Get-MarkdownMetaState.ps1.md

`automation/Catzc.Base.MarkdownMeta/Get-MarkdownMetaState.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Pure: it takes the text, reads no file and no config. The body is what follows the front matter, and its hash drops the
blank line that separates written front matter from it, so imprinting never changes the hash it records
([ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
```
