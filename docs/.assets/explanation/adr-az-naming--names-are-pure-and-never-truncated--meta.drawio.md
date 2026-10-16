---
catzc:
  immutable:
    with_body_sha: "192ccc156202"
    path: docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-az-naming-names-are-pure-and-never-truncated-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md
      - docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.png
      - docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md
      - docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md
      - docs/explanation/azure/names-are-pure-and-never-truncated.md
---

# Names are pure and never truncated: the diagram described

```text
A 1572 x 670 diagram, read top to bottom through three bands.
Glyphs: 2 named sets (mauve), 1 gate, 1 failure, 1 result; 3 flow edges, 1 failure path; 5 markers.
Sidebar: world-map grid (4 lit cells), tree (7 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/names-are-pure-and-never-truncated.md).

## At a glance

A 1572 × 670 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled COMPONENTS, PATTERN and LIMIT. Five glyphs (two named sets, one gate, one failure and one result) stand in one
centred column, with the failure to the right of the gate. Three flow edges and one failure path join them, and five markers and a legend
panel complete the drawing. The eye lands first on the gate in the limit band.

## Reading path

1. Marker 1, components band: the named set fixed components.
2. Down to marker 2, pattern band: the named set type pattern.
3. Down to marker 3, limit band: the gate ≤ limit?, its marker on the gate's upper-left side.
4. Right along the red edge to marker 4: the failure throw.
5. Down from the gate to marker 5: the result the same name.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                           |
| --------------------- | ----- | --------------------------------------------------------------- |
| named set             | 2     | fixed components (components band), type pattern (pattern band) |
| gate                  | 1     | ≤ limit? (limit band, centre)                                   |
| failure               | 1     | throw (limit band, right of the gate)                           |
| result                | 1     | the same name (limit band, below the gate)                      |

Named sets are mauve with white names; the gate is grey with a thick rim.

## Edges

| Edge kind    | Count | From → to                                                  |
| ------------ | ----- | ---------------------------------------------------------- |
| flow         | 3     | fixed components → type pattern → ≤ limit? → the same name |
| failure path | 1     | ≤ limit? → throw                                           |

Every edge is straight; the flow edges are vertical and the failure path horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| mauve rounded box       | named set                  |
| grey rhombus, thick rim | gate                       |
| red rounded box         | failure                    |
| green rounded box       | result                     |
| grey arrow              | flow: the next stage       |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md),
[tree](adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md) and
[value-chain map](adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AZ-NAMING); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-AZ-NAMING);
  `automation × .ps1` (7 files: 7 cite ADR-AZ-NAMING); `automation × .yml` (4 files: 4 cite ADR-AZ-NAMING); `docs × .md` (4 files: 3 cite
  ADR-AZ-NAMING; 1 is the ADR file of ADR-AZ-NAMING).
- **Tree** (the repository's files): 7 lit groups, `Az.Templates` (7 files); `Azure` (4 files); `Docs` (2 files); `adr/azure` (2 files);
  `Variants` (1 file); `adr/*` (1 file); `docs` (1 file). The ADR file `docs/adr/azure/azure-naming-standard.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `CLOUD × DEPLOY`, because ADR-AZ-NAMING: its
  ADR domain `azure` sits on the CLOUD row (ADR-DSGN-TRACK#14), and deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
