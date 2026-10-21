# pwsh/Catzc.Base.Slides/private/Get-DiagramMinimapReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the minimap reasons a diagram folder's verify record names, one record per lit minimap.

### description

Reads the `## Minimap reasons` section of a `diagram.drawio.verify.md`, one judged line per lit minimap, `- <minimap>: <reason>`. A line
Prettier wrapped continues the reason above it. A file without the section, or no file at all, names no reason. A line outside the form, a
minimap that is not one of the eight ids, or a minimap named twice fails, with every such line in one throw
(ADR-REPO-SLIDES-MINIMAPSFROMDATA).

### parameter `Path`

The verify record to read.

### outputs

`[pscustomobject]` One record per named minimap: `Minimap`, `Reason`, `Line`.
