---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md
    kind: comment-page
    body_sha: d4f04fdd8aca
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.Maps/types/MapsLimits.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

```text
The world-map limits (the `limits` section of configs/maps.yml): the page size in PDF points, the smallest font size
a label may shrink to, and the longest track and file-language name a row or column header prints before it is
shortened. The properties mirror the YAML keys, so they are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults are declared
here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an A4 landscape
page. MapsConfig validates the section (every value positive) and builds one.
```
