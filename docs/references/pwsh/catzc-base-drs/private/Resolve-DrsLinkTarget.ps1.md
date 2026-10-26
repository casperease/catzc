# pwsh/Base.Drs/private/Resolve-DrsLinkTarget.ps1

The private helper that turns a markdown link written in a `docs/drs/` file into the target's path under `docs/drs/`, for the link-reading
checks.

## help

### synopsis

Resolves a markdown link's target, written in a file under docs/drs/, to its path under docs/drs/.

### description

A markdown link is relative to its own file
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). This drops the
target's #fragment, resolves the rest against the linking file's folder, and returns the result relative to docs/drs/ ('/'-separated). It
returns nothing for a link that names no file under docs/drs/: an in-page anchor, an absolute URL, a repository-rooted path, or a relative
path that leaves docs/drs/.

Private helper for the citation-graph and DORA-coverage checks of Test-DrsRegistry; not exported.

### parameter `DrsRoot`

The absolute docs/drs/ folder.

### parameter `From`

The linking file's path under docs/drs/ ('/'-separated).

### parameter `Target`

The link's target, as written between the parentheses.

### outputs

`[string]` The target's path under docs/drs/, or nothing.
