---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapsPin.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6bf3086aa0e0"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/MapsPin.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
One reviewed highlight entry of configs/maps.yml (an item of `highlight.pins` or `highlight.exceptions`): an ADR code
(optionally one rule of it, the code followed by #n), the cell it names (a track and a file language), and why it was reviewed. A pin
lights the cell for the ADR; an exception keeps the cell dark although the ADR's citations would light it (a passing
mention). The properties mirror the YAML keys, so they are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). MapsConfig validates
the shape; whether the track and the file language exist is checked against their registries where the map is
built.
```
