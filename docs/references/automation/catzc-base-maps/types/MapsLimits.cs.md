---
catzc:
  immutable:
    with_body_sha: "4a9e3ca18e0d"
    path: docs/references/automation/catzc-base-maps/types/MapsLimits.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: maps-limits-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/MapsLimits.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
The world-map limits (the `limits` section of configs/maps.yml): the page size in PDF points, the smallest font size
a label may shrink to, and the longest track and file-language name a row or column header prints before it is
shortened. The properties mirror the YAML keys, so they are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The defaults are declared
here, once ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an A4 landscape
page. MapsConfig validates the section (every value positive) and builds one.
```
