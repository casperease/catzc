# pwsh/Catzc.Base.Maps/Export-MinimapData.ps1

<!-- cspell:ignore minimaps -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The minimap data step: reads the two map processors for a list of slides and writes the data the diagram kit draws from.

### description

Writes into -Data, for the `minimap_render.py` and `minimap_join.py` scripts of the `Catzc.Diagrams` module of the python track (its
`assets/STYLE.md`):

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

### parameter `Slides`

The slide list: a JSON file { "slides": [ { "id", "stem", "lens", "adrs": `[...]`, "xml" } ] }.

### parameter `Data`

The folder the data files go to; created when missing. Default: out/minimaps under the repository root.

### example 1

```powershell
Export-MinimapData -Slides out/diagrams/k4/slides.docs.json
```

## comment:1

Above `$printed = [ordered]@{`, written with `#`.

```text
The printed labels: a bucket key prints as its defined term
([ADR-DSGN-TRACK-ROOTFILE](/docs/adr/design/tracks.md#rule-adr-dsgn-track-rootfile), #8, #13), the value-chain map as its
value_chain_* labels.
```

## comment:2

Above `$citations = Get-AdrCitationMap`, written with `#`.

```text
The link targets of the sister .md files: every ADR code's file (the link engine's own map), and every glossary term
with the rule that defines it.
```
