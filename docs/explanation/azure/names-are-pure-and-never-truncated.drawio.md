---
catzc:
  immutable:
    with_body_sha: "7a0ba47bab0b"
    repo_status: clean
    path: docs/explanation/azure/names-are-pure-and-never-truncated.drawio.md
    folder: docs/explanation/azure
    name: names-are-pure-and-never-truncated-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.png
      - docs/explanation/.assets/chain/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md
      - docs/explanation/.assets/grid/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md
      - docs/explanation/.assets/tree/adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md
      - docs/explanation/azure/names-are-pure-and-never-truncated.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Names are pure and never truncated: the diagram described

```text
A 1572 x 670 diagram, read top to bottom through three bands.
Glyphs: 2 named sets (mauve), 1 gate, 1 failure, 1 result; 3 flow edges, 1 failure path; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-naming--names-are-pure-and-never-truncated--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](names-are-pure-and-never-truncated.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md),
[tree](../.assets/tree/adr-az-naming--names-are-pure-and-never-truncated--meta.tree.md) and
[value-chain map](../.assets/chain/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
