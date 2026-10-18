# pwsh/Catzc.Base.Docs/private/Resolve-AdrLinkTarget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a markdown link's target, written in a file under docs/adr/, to its path under docs/adr/.

### description

A markdown link is relative to its own file
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../adr/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). This drops the
target's #fragment, resolves the rest against the linking file's folder, and returns the result relative to docs/adr/ ('/'-separated). It
returns nothing for a link that names no file under docs/adr/: an in-page anchor, an absolute URL, a repository-rooted path, or a relative
path that leaves docs/adr/.

Private helper for the citation-graph and DORA-coverage checks of Test-AdrRegistry; not exported.

### parameter `AdrRoot`

The absolute docs/adr/ folder.

### parameter `From`

The linking file's path under docs/adr/ ('/'-separated).

### parameter `Target`

The link's target, as written between the parentheses.

### outputs

`[string]` The target's path under docs/adr/, or nothing.
