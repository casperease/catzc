---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapsPalette.cs.md
    kind: comment-page
    body_sha: cae559483927
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/MapsPalette.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

```text
The world-map palette (the `palette` section of configs/maps.yml): the page background, the fill colours of the track
rows, the file-language columns, an empty cell and the fullest cell, the grid lines, the text, a stack-violation mark
and a highlighted (lit) cell's outline, each a '#' and six hex digits. The properties mirror the YAML keys, so they are
snake_case ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults
are declared here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), and
the dark-theme tokens of the diagram kit (.claude/drawio/STYLE.md), which the slide minimaps share: the dark page, light
text, an idle cell in the band fill, a scale that rises from the idle fill to the light ink, the kit's only red for a
violation mark, and the light ink as the lit colour. MapsConfig validates the section and builds one.
```
