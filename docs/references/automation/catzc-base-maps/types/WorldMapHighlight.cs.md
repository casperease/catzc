---
catzc:
  immutable:
    with_body_sha: "329eba9a7924"
    repo_status: locked
    path: docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: world-map-highlight-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-DSGN-TRACK#1
      - ADR-THES-ONETRUTH#3
---

# automation/Catzc.Base.Maps/types/WorldMapHighlight.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A world-map highlight: the cells a request lights. A request is either ADR references or a drawing's files
([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1) places each file in one cell).

ADR references (ForAdr) light, through the placements WorldMapBuilder derived in its fixed order per artifact kind:
each requested ADR's own file (an ADR-<CODE>#n request lights its ADR's file), and every file whose citations a request
covers (CitationScanner.Covers). An ADR's domain never lights a file: it only picks the value-chain row.
Then the reviewed overrides of configs/maps.yml apply: an exception a request covers keeps its cell dark, and a pin a
request covers lights its cell, so a pin wins over an exception. Files (ForPaths) light the cells they sit in. Every
lit file, and every pin, carries its reason (HighlightReason): the basis, the covering request, and the citation
sites with their lines and kinds, so a lit file cited only in passing comments reads as a mention.

The cells keep the map's order (rows, then columns), so the result is deterministic; ToJson is its data form
([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```

## comment:2

Above `public static WorldMapHighlight ForAdr(WorldMap map, IEnumerable references,...`, written with `//`.

```text
The cells ADR references light (each ADR-<CODE>, ADR-<CODE>#n or ADR-<CODE>:n), with the reviewed pins and
exceptions (MapsPin items) applied. A reference that is not an ADR code the map's index lists throws, and so does
a pin or exception that names a cell the map does not have.
```
