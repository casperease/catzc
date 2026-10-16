---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "19b4d0c959ec"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#{7,8,16}
---

# automation/Catzc.Base.Maps/types/MapsLabels.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
The map labels (the `labels` section of configs/maps.yml): the fixed text the maps print beside the data.

The world map's labels: the title of each view, the header of each axis, the headers of the two catch-all lines of the
grid and the legend's entries. The catch-all row holds the root files
([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7)) and the catch-all column the unlisted files
([ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8)), so their headers print those terms.

The value-chain map's labels, each key starting value_chain_: its title, the header of each axis (the value-chain
stack and the value-chain concerns) and the legend's entries
([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). Test-WorldMap checks the world map's
labels and Test-ValueChainMap the value-chain map's.

The properties mirror the YAML keys, so they are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults are declared
here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). MapsConfig
validates the section (every label one non-empty line of WinAnsi text, each world-map row or column header within
its limit) and builds one.
```
