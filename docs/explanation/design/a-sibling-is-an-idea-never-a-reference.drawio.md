---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/design/a-sibling-is-an-idea-never-a-reference.drawio.md
    folder: docs/explanation/design
    name: a-sibling-is-an-idea-never-a-reference-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.drawio.png
      - docs/explanation/.assets/chain/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.chain.md
      - docs/explanation/.assets/grid/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.grid.md
      - docs/explanation/.assets/tree/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.tree.md
      - docs/explanation/design/a-sibling-is-an-idea-never-a-reference.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# A sibling is an idea, never a reference: the diagram described

```text
A 1572 x 640 diagram, read left to right across three bands, then down into the crossing.
Glyphs: 2 stores (slate), 1 named set (mauve), 1 gate (grey rhombus), 1 result (green); 3 flow edges; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](a-sibling-is-an-idea-never-a-reference.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three bands sit side by side under the title,
labelled `SIBLING: EAC, GO` on the left, `WHERE THE MODELS MEET` in the middle and `CATZC: POWERSHELL AND C#` on the right. The outer bands
each hold one slate store, with a quiet note at the foot of the band; the middle band holds one wide mauve named set at the top and a grey
rhombus below it. A green result sits low in the right band. Three thin edges run from the left store down and across to the rhombus, from
the rhombus to the result, and from the result up into the right store. A legend panel runs along the bottom. The eye lands first on the two
cylinders.

## Reading path

1. Marker 1, left: the store eac, the sibling repository; at the foot of its band, what eac keeps as its own.
2. Marker 2, middle top: the named set the shared model, with the five points both repositories hold.
3. Marker 3, middle: the gate the owning ADR decides, which the edge an idea, named where it is used reaches from the left store.
4. Marker 4, right: the result rebuilt to catzc's rules, one living version, whose edge lands as a rule ends in the store catzc.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                  |
| --------------------- | ----- | ------------------------------------------------------ |
| store                 | 2     | eac (left band), catzc (right band)                    |
| named set             | 1     | the shared model (middle band, top)                    |
| gate                  | 1     | the owning ADR decides (middle band, below the set)    |
| result                | 1     | rebuilt to catzc's rules (right band, below the store) |

The stores are slate, the named set mauve, the gate a grey rhombus with a thick rim, the result green; names are white.

## Edges

| Edge kind | Count | From → to                                                                                                                                 |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | eac → the owning ADR decides (an idea, named where it is used); the gate → rebuilt to catzc's rules; the result → catzc (lands as a rule) |

Every edge is orthogonal with rounded corners and points along the reading path. None crosses another. Two carry a label on the page colour;
the edge from the gate to the result carries none.

## Notes

Two quiet lines of text, one at the foot of each outer band, name what each repository keeps as its own: a rule as a `.feature`
specification and no unordered file (eac); a rule as an ADR cited by code and `.unordered` as the landing zone of an import (catzc). They
are text, not glyphs.

## Legend

A full-width panel at the bottom of the drawing area, in one row of six, left to right:

| Swatch            | Phrase                         |
| ----------------- | ------------------------------ |
| slate cylinder    | store: a repository            |
| mauve rounded box | named set: the model both hold |
| grey rhombus      | gate: the owning ADR           |
| green rounded box | result: a rule rebuilt here    |
| thin arrow        | flow: an idea crosses          |
| light disc `1`    | marker: a step                 |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-PRIN-ONELIVE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.grid.md),
[tree](../.assets/tree/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.tree.md) and
[value-chain map](../.assets/chain/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-PRIN-ONELIVE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
