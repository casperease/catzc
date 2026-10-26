# pwsh/Base.CodeMeta/Get-CommentPage.ps1

The one place a file's path is turned into its comment page's path. It walks the `pages:` entries of `comment-pages.yml` in order and the
first entry that covers the path decides, so the export, the view and the gates all agree on where a page lives. See
[comment-pages.yml](configs/comment-pages.yml.md) for the entries.

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
