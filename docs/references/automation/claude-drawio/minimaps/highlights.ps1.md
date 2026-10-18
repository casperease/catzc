# .claude/drawio/minimaps/highlights.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The minimap data step: reads the two map processors (module Catzc.Base.Maps) for a list of slides.

### description

Writes into -Data, for render.py and join.py next to this script (.claude/drawio/STYLE.md):

```text
world-map.json        Get-WorldMap -AsJson
value-chain-map.json  Get-ValueChainMap -AsJson
file-languages.json   each file language's extensions (Get-FileLanguage)
palette.json          the maps.yml palette the minimaps share with the world-map PDFs
labels.json           the printed terms: the two bucket keys' labels and the value_chain_* labels of maps.yml
references.json       every ADR code's file (Get-AdrCitationMap) and every glossary term with its defining rule
highlights.json       per slide id: the world-map and the value-chain highlight of the slide's ADR codes, each
                      with its reasons (Get-WorldMapHighlight, Get-ValueChainHighlight -Adr <codes> -AsJson)
```

A slide whose ADR codes the maps do not know fails the run, listing every such slide.

### parameter Slides

The slide list: a JSON file { "slides": [ { "id", "stem", "lens", "adrs": `[...]`, "xml" } ] }.

### parameter Data

The folder the data files go to; created when missing. Default: out/minimaps under the repository root.

### example 1

```powershell
pwsh -NoProfile -File .claude/drawio/minimaps/highlights.ps1 -Slides out/diagrams/k4/slides.docs.json
```
