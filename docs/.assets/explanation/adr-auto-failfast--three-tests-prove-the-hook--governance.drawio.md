---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-failfast--three-tests-prove-the-hook--governance.drawio.md
    kind: asset-description
    body_sha: "0842b420d8eb"
    links:
      - docs/.assets/explanation/adr-auto-failfast--three-tests-prove-the-hook--governance.drawio.png
      - docs/explanation/automation/three-tests-prove-the-hook.md
---

# Three tests prove the hook: the diagram described

```text
A 1572 x 720 diagram in two columns: the left read top to bottom through four bands, the right one band of gates.
Glyphs: 3 code units (slate), 3 gates (neutral), 1 ADR-only; 2 flow edges; 4 rule chips (1 dashed); 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-failfast--three-tests-prove-the-hook--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/three-tests-prove-the-hook.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two columns. The left column
reads top to bottom through four bands, labelled `LIMITS`, `VERDICT`, `HOOK` and `NO GATE`; the right column is one band, `TESTS`, level
with the `VERDICT` and `HOOK` bands. It holds seven glyphs, three code units, three gates and one ADR-only, joined by two flow edges, with
four rule chips, seven markers and a legend panel along the bottom. The eye lands first on the three neutral rhombi in the right column.

## Reading path

1. Markers 1, 2 and 3, left column, top to bottom: the code units TimeoutsConfig, BashSafeguard.Decide and Assert-BashTimeout, joined by two
   flow edges, each with a rule chip to its right: `#7 · D6`, `#7`, `#7`.
2. Marker 4, `TESTS` band, top: the gate BashSafeguard (L0 logic).
3. Markers 5 and 6, `TESTS` band, bottom, left to right: the gates parity (L1 integrity) and published hook (L2 logic).
4. Marker 7, `NO GATE` band: the ADR-only glyph timeout-exemptions.yml, with a dashed rule chip `#7`, joined to nothing.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                            |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------ |
| code unit             | 3     | TimeoutsConfig (`LIMITS`), BashSafeguard.Decide (`VERDICT`), Assert-BashTimeout (`HOOK`)         |
| gate                  | 3     | BashSafeguard (L0 logic), parity (L1 integrity), published hook (L2 logic) (`TESTS`), thick rims |
| ADR-only              | 1     | timeout-exemptions.yml (`NO GATE`), dashed outline on the page colour                            |

Code units are slate with light names; the gates are neutral rhombi, dark with a light rim; the ADR-only glyph is a dashed box with no fill
of its own.

## Edges

| Edge kind | Count | From → to                                                                        |
| --------- | ----- | -------------------------------------------------------------------------------- |
| flow      | 2     | TimeoutsConfig → BashSafeguard.Decide, BashSafeguard.Decide → Assert-BashTimeout |

Both edges are straight and vertical. No edge carries a chip. Four rule chips sit beside the glyphs they govern, one each; three are solid
and the chip beside the ADR-only glyph is dashed.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| slate rounded box | code unit                            |
| neutral rhombus   | gate                                 |
| dashed box        | ADR-only                             |
| light arrow       | flow: feeds the next step            |
| chip `#7`         | rule chip: # = FAILFAST, D = DEFAULT |
| dashed chip `#7`  | dashed rule chip: ADR-only (no gate) |
| light disc `1`    | marker: a Walkthrough step           |

## Sidebar

The lens badge reads `GOV`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below it
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
