# docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md

`Bind to one CLI; delegate the rest: the diagram described`

```text
A 1572 x 750 diagram, read top to bottom through four bands down one centre spine.
Glyphs: 1 actor, 1 code unit (slate), 1 external tool, 1 environment; 3 flow edges; 4 markers.
Sidebar: world-map grid (2 lit cells), tree (4 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/bind-to-one-cli-delegate-the-rest.md).

## At a glance

A 1572 × 750 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled CONSUMERS, CLI SURFACE, DELEGATED and VENDOR SUBSTRATE, down one centre spine. It holds four glyphs, one per band
(an actor, a code unit, an external tool and an environment), joined by three flow edges, with four markers and a legend panel along the
bottom. The eye lands first on the slate code unit in the CLI SURFACE band, the only dark glyph.

## Reading path

1. Marker 1, CONSUMERS band: the actor developer.
2. Down to marker 2, CLI SURFACE band: the code unit one CLI.
3. Down to marker 3, DELEGATED band: the external tool vendor tooling.
4. Down to marker 4, VENDOR SUBSTRATE band: the environment cloud vendor.

## Glyphs

| Glyph (legend phrase) | Count | Where                                   |
| --------------------- | ----- | --------------------------------------- |
| actor                 | 1     | developer (CONSUMERS, centre)           |
| code unit             | 1     | one CLI (CLI SURFACE, centre)           |
| external tool         | 1     | vendor tooling (DELEGATED, centre)      |
| environment           | 1     | cloud vendor (VENDOR SUBSTRATE, centre) |

The code unit is slate with a white name; the others are white or neutral grey.

## Edges

| Edge kind | Count | From → to                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------- |
| flow      | 3     | developer → one CLI, one CLI → vendor tooling, vendor tooling → cloud vendor |

All three edges are straight and vertical on one line.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| white circle      | actor                      |
| slate rounded box | code unit                  |
| grey square box   | external tool              |
| grey hexagon      | environment                |
| grey arrow        | flow: uses                 |
| dark disc `1`     | marker: a Walkthrough step |
| grey band         | band: one layer            |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md),
[tree](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md) and
[value-chain map](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-THINPLAT); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (2 files: 2 cite ADR-DSGN-THINPLAT);
  `docs × .md` (3 files: 2 cite ADR-DSGN-THINPLAT; 1 is the ADR file of ADR-DSGN-THINPLAT).
- **Tree** (the repository's files): 4 lit groups, `adr/dsgn` (2 files); `Docs` (1 file); `QualityGates` (1 file); `adr/*` (1 file). The ADR
  file `docs/adr/design/thin-platforms.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × AUTOMA`, because ADR-DSGN-THINPLAT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-THINPLAT: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, deploy is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-DSGN-THINPLAT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
