# pwsh/Catzc.Base.Slides/private/Get-DiagramArticleStem.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$pattern = '(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[...`, written with `#`.

```text
The stems of the diagrams an article declares: each `yml drawio` block directly above an image embedding `.assets/<name>.drawio.png`,
as `<page folder>/.assets/<name>`. A slide is never a carrier, so a block in one names nothing.
```
