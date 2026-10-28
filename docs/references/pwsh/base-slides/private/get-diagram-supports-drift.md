# pwsh/Base.Slides/private/Get-DiagramSupportsDrift.ps1

The drift check between a diagram and the pages that embed it: it returns one finding, an error, per page whose Supports line disagrees with
the diagram's declaration.

## help

### synopsis

Holds each page that embeds a diagram against the diagram's declaration.

### description

Reads each page's `Supports <codes> (<lens> lens)` lines and the diagram's `<name>.drawio.yml` (about.rules, about.lens). A page passes when
one of its lines names the declaration's codes and lens; a page with no Supports line, or a diagram without a declaration, is not checked
(ADR-REPO-SLIDES-ONEBUILDCOMMAND).

### parameter `Stem`

The diagram's stem, `.assets/<name>`, repository-relative.

### parameter `Page`

The pages that embed the diagram's png, repository-relative.

### parameter `RepositoryRoot`

The repository root the paths are under.

### outputs

`[string]` One line per page whose Supports line disagrees with the declaration.

## Wrapped lines

A Supports line may wrap onto the next lines of its fence; its codes hold no parenthesis or backtick, so a match never leaves it.
