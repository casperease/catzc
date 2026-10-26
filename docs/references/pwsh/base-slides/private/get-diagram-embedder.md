# pwsh/Base.Slides/private/Get-DiagramEmbedder.ps1

The map from each diagram's stem to the pages that embed its png.

## help

### synopsis

Finds every page that embeds a diagram, by the diagram's stem.

### description

Reads each tracked markdown page once and resolves its image links to a `<name>.drawio.png`, so a diagram may be embedded by any number of
articles and slides and names none of them (ADR-REPO-SLIDES-ONEBUILDCOMMAND). A tracked page missing from the disk is skipped.

### parameter `Tracked`

The repository's tracked paths, repository-relative.

### parameter `RepositoryRoot`

The repository root the paths are under.

### outputs

`[hashtable]` diagram stem, `.assets/<name>` (repository-relative), to the list of pages that embed its png.

## Resolving links

An image link resolves from the page's own folder, or from the repository root for a link that starts with `/`. Any number of pages may
embed one diagram; the diagram names none of them.
