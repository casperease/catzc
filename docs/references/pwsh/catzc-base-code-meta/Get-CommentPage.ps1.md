# pwsh/Base.CodeMeta/Get-CommentPage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names the comment page a file's path maps to, or nothing when no pages entry covers it.

### description

Pure: it asks the given comment-pages config for the page, reads no file and checks no page exists. The page is derived from the file's
path, as [ADR-REPO-COMMENTS-COMMENTPAGEPLACE](../../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-commentpageplace) places
it, and the first pages entry that covers the path decides.

### parameter `Path`

The file's path, relative to the repository root. An empty path maps to nothing.

### parameter `Config`

The comment-pages config: a Catzc.Base.CodeMeta.CommentPagesConfig.

### outputs

`[string]` — the page's path, relative to the repository root; nothing when no pages entry covers the file.

### example 1

```powershell
Get-CommentPage -Path 'pwsh/Base.CodeMeta/Get-CommentPage.ps1' -Config (Get-Config -Config comment-pages)
```
