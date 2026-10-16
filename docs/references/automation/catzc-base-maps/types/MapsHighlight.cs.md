---
catzc:
  immutable:
    with_body_sha: "80eb6f98e58e"
    path: docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: maps-highlight-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/MapsHighlight.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The world-map highlight settings (the `highlight` section of configs/maps.yml): the reviewed pins, which light a cell
for an ADR, the reviewed exceptions, which keep one dark, and the globs of the files whose citations light nothing
(citation_exclude). The pin and exception lists default to empty, so the highlight follows the derived order alone;
citation_exclude defaults to DefaultCitationExclude: the generated slide descriptions under docs/.assets/, the
explanation articles under docs/explanation/ and the drawing tooling under .claude/drawio/, so a slide's minimap lights
the repository's citations of its ADRs, never the slide's own words or the tool that drew it
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). An excluded file still sits
in its world-map cell; only its citations are ignored. The properties mirror the YAML keys, so they are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). MapsConfig validates the
section and builds one.
```

## comment:2

Above `public static readonly IReadOnlyList<string> DefaultCitationExclude =`, written with `//`.

```text
The files whose citations light nothing by default: the generated slide descriptions and every other asset, the
explanation articles the slides illustrate, and the drawing tooling that makes them.
```

## comment:3

Above `public IReadOnlyList<string> citation_exclude { get; }`, written with `//`.

```text
The globs (repository-relative, '/'-separated) of the files whose citations light nothing. Default:
DefaultCitationExclude.
```
