---
catzc:
  immutable:
    with_body_sha: "52ed2e3c105c"
    repo_status: clean
    path: docs/explanation/design/out-of-band-deploy-is-adr-only.drawio.md
    folder: docs/explanation/design
    name: out-of-band-deploy-is-adr-only-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md
      - docs/explanation/design/out-of-band-deploy-is-adr-only.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# No gate checks the out-of-band deploy rule: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 4 commits, 2 gates, 1 environment, 1 ADR-only; 4 flow edges, 2 ADR-only edges; 6 rule chips; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](out-of-band-deploy-is-adr-only.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING, with a span bar labelled CI above the MAIN and AFTER
LANDING bands. It holds eight glyphs: four commits, two gates, one environment and one ADR-only glyph, plus six rule chips. A straight flow
line runs across the top row from the brown commit to the yellow one; a dashed path drops from the brown commit into the OUT-OF-BAND band,
and a short flow edge drops from the grey commit to a second gate. Six markers number the reading order, and a legend panel runs along the
bottom.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic, with the rule chips V2 and V4 to its left.
2. Down the dashed edge and right to marker 2, OUT-OF-BAND band: the dashed white pill, out-of-band deploy, with the chip L9.
3. Down the dashed edge to marker 3: the environment hexagon with a small brown commit inside, and the chip V13.
4. Back to the top row, along the flow edge to marker 4, MAIN band: the grey commit, main, with the chip L1.
5. Down the flow edge to marker 5, MAIN band: the gate main only.
6. Marker 6, AFTER LANDING band: the gate BVT, then on to the yellow commit BVT-verified, with the chip V4.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| commit                | 4     | brown topic (TOPIC), grey main (MAIN), yellow BVT-verified (AFTER LANDING), small brown occupant inside the environment |
| gate                  | 2     | main only (MAIN, middle), BVT (AFTER LANDING, top row); both with a 3 px rim                                            |
| environment           | 1     | environment (OUT-OF-BAND, bottom)                                                                                       |
| ADR-only              | 1     | out-of-band deploy (OUT-OF-BAND, middle), a dashed white pill                                                           |

The commits keep the locked commit palette; the gates and the environment are neutral grey. Six rule chips sit beside the glyphs they
govern: V2 and V4 left of topic, L9 right of out-of-band deploy, V13 right of the environment, L1 above-right of main, and V4 right of
BVT-verified.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 4     | topic → main, main → BVT, BVT → BVT-verified, main → main only                                                                                                                       |
| ADR-only  | 2     | topic → out-of-band deploy (one dashed edge drawn as two cells: a down leg with no arrowhead to a bend point, then a right leg with the arrowhead), out-of-band deploy → environment |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                                            |
| --------------------------------- | ------------------------------------------------- |
| brown, grey and yellow discs      | commit (locked palette)                           |
| grey rhombus with a thick rim     | gate: code checks it                              |
| grey hexagon                      | environment: its occupant inside                  |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge                 |
| white chip `L9`                   | rule chip: L = ADR-DSGN-LIFE, V = ADR-DSGN-VISUAL |
| thin arrow                        | flow: lands, then climbs                          |
| dark disc `1`                     | marker: a Walkthrough step                        |
| crossbar                          | span bar: stages over bands                       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE and ADR-DSGN-VISUAL): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md),
[tree](../.assets/tree/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-DSGN-LIFE and ADR-DSGN-VISUAL" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
