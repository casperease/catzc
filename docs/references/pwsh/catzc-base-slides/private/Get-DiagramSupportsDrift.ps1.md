# pwsh/Catzc.Base.Slides/private/Get-DiagramSupportsDrift.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Holds each page that embeds a diagram against the diagram's declaration.

### description

Reads each page's `Supports <codes> (<lens> lens)` lines and the folder's `diagram.drawio.yml` (about.adrs, about.lens). A page passes
when one of its lines names the declaration's codes and lens; a page with no Supports line, or a folder without a declaration, is not
checked (ADR-REPO-SLIDES-ONEBUILDCOMMAND).

### parameter `Folder`

The diagram folder, repository-relative.

### parameter `Page`

The pages that embed the folder's png, repository-relative.

### parameter `RepositoryRoot`

The repository root the paths are under.

### outputs

`[string]` One line per page whose Supports line disagrees with the declaration.

## comment:1

Above `$source = Join-Path $RepositoryRoot "$Folder/diagram.drawio.yml"`, written with `#`.

```text
Each embedding page's `Supports <codes> (<lens> lens)` lines against the diagram's yml: a page passes when one of its lines
names the yml's ADR codes and lens, and a page with no Supports line is not checked. One warning per page that disagrees.
```
