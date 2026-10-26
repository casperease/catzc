# pwsh/Base.Slides/private/Get-DiagramArticleStem.ps1

The finder of article-declared diagrams: it returns the stems of the diagrams whose declaration is a `yml drawio` block in an article.

## help

### synopsis

Names the diagrams the articles declare, from their `yml drawio` blocks.

### description

Each `yml drawio` block that stands directly above an image embedding `.assets/<name>.drawio.png` declares that diagram, so a diagram that
has no png yet is found from its block. A slide is never a carrier, and a page that is not on disk is skipped.

### parameter `RepositoryRoot`

The repository root the pages are under.

### parameter `Candidate`

The repository-relative paths to look in: the tracked files and the changed ones.

### outputs

`[string]` The stem of each declared diagram, `<page folder>/.assets/<name>`.

### example 1

```powershell
Get-DiagramArticleStem -RepositoryRoot $root -Candidate (Get-GitTrackedPath '.')
```

## Naming the png

An inline image names its png; a reference names it through its definition, and one naming no diagram is no stem. A slide is never a
carrier, so a block in one names nothing.
