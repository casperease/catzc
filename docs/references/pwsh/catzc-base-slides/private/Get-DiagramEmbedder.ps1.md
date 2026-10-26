# pwsh/Catzc.Base.Slides/private/Get-DiagramEmbedder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$embedders = @{}`, written with `#`.

```text
Every page that embeds a diagram, by the diagram's stem: each tracked markdown page's image links to a <name>.drawio.png,
resolved from the page's own folder, or from the repository root for a link that starts with '/'. Any number of pages may
embed one diagram; the diagram names none of them.
```

## comment:2

Above `$embedders = @{}`, written with `#`.

```text
Stem to embedding pages: links resolve from the page's folder, or the root for '/'; a diagram names none of its
pages.
```
