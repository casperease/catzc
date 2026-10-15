---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapsLabels.cs.md
    kind: reference
    body_sha: c124d31779da
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#7
      - ADR-DSGN-TRACK#8
---

# automation/Catzc.Base.Maps/types/MapsLabels.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

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
