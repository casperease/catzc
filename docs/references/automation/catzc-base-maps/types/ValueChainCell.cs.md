---
catzc:
  immutable:
    with_body_sha: a7b54b309a80
    path: docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: value-chain-cell-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#{10,16}
---

# automation/Catzc.Base.Maps/types/ValueChainCell.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One cell of the value-chain map: a row of the value-chain stack crossed with a value-chain concern, and the ADRs
that sit in it ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16),
[ADR-DSGN-TRACK#10](/docs/adr/design/tracks.md#rule-adr-dsgn-track10)). On the map, Adrs holds every ADR of the cell;
on a highlight, the requested ADRs that light it. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```

## comment:2

Above `public IReadOnlyList<string> Adrs { get; }`, written with `//`.

```text
The ADR codes (ADR-<CODE>) in the cell: on the map in adrs.yml order, on a highlight in request order. Empty for an
empty cell of the grid.
```
