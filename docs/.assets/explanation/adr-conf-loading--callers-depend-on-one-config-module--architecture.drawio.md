---
catzc:
  derived:
    path: docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "2419ee9792e2"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
      - docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.png
      - docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
      - docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md
      - docs/explanation/configuration/callers-depend-on-one-config-module.md
---

# Callers anywhere depend on one module: the diagram described

```text
A 1572 x 700 diagram, read left to right along one band, down into a second band and back up, with a third band below.
Glyphs: 4 code units (slate), 1 store (slate), 1 file (olive), 1 result; 7 flow edges; 7 markers; 1 fraction chip.
Sidebar: world-map grid (4 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-conf-loading--callers-depend-on-one-config-module--architecture.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/configuration/callers-depend-on-one-config-module.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled READ PATH, down into a band labelled MISS on the right, and back up; a band labelled QUALITY GATES sits bottom
left. It holds seven glyphs (four code units, one store, one file and one result) joined by seven edges, with seven markers, one fraction
chip and a legend panel along the bottom. The eye lands first on the READ PATH band and its slate cylinder.

## Reading path

1. Marker 1, READ PATH band: the code unit caller, at the left, with the fraction chip 26/39 above its outgoing edge.
2. Marker 2: the code unit Catzc.Base.Config.
3. Marker 3: the store session cache.
4. Marker 4: the result typed or raw, at the right end of the band.
5. Down from the store to marker 5, MISS band: the file configs/&lt;name&gt;.yml.
6. Right to marker 6: the code unit owner's C# type, and up from its right part into the result.
7. Marker 7, QUALITY GATES band: the code unit Catzc.Base.QualityGates, with a long edge up into Catzc.Base.Config.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------- |
| code unit             | 4     | caller and Catzc.Base.Config (READ PATH, left), owner's C# type (MISS, right), Catzc.Base.QualityGates (QUALITY GATES) |
| store                 | 1     | session cache (READ PATH, middle)                                                                                      |
| file                  | 1     | configs/&lt;name&gt;.yml (MISS, left, below the store)                                                                 |
| result                | 1     | typed or raw (READ PATH, right)                                                                                        |

Code units and the store are slate and the file is olive, all with white names; the result is light green.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 7     | caller → Catzc.Base.Config (fraction chip 26/39), Catzc.Base.Config → session cache, session cache → typed or raw, session cache → configs/&lt;name&gt;.yml, configs/&lt;name&gt;.yml → owner's C# type, owner's C# type → typed or raw, Catzc.Base.QualityGates → Catzc.Base.Config |

Every edge is straight and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                                            |
| ------------------------- | ------------------------------------------------- |
| slate rounded box         | code unit                                         |
| slate cylinder            | store                                             |
| olive page, folded corner | file                                              |
| light green rounded box   | result                                            |
| thin arrow                | flow: calls, or the read (hit right, miss down)   |
| bold `26/39`              | fraction chip: other modules that call the reader |
| dark disc `1`             | marker: a Walkthrough step                        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md),
[tree](adr-conf-loading--callers-depend-on-one-config-module--architecture.tree.md) and
[value-chain map](adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-CONF-LOADING); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (6 files: 6 cite ADR-CONF-LOADING);
  `automation × .ps1` (11 files: 11 cite ADR-CONF-LOADING); `automation × .yml` (1 file: 1 cites ADR-CONF-LOADING); `docs × .md` (5 files: 4
  cite ADR-CONF-LOADING; 1 is the ADR file of ADR-CONF-LOADING).
- **Tree** (the repository's files): 10 lit groups, `Docs` (9 files); `Config` (2 files); `Git` (2 files); `QualityGates` (2 files);
  `adr/conf` (2 files); `docs` (2 files); `Execution` (1 file); `ModuleSystem` (1 file); `RootConfig` (1 file); `adr/*` (1 file). The ADR
  file `docs/adr/configuration/module-config-loading.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `AUTO × LOCAL`, because ADR-CONF-LOADING:
  its ADR domain `configuration` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern
  (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-CONF-LOADING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
