---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "4a4012b3a559"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md
      - docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.png
      - docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md
      - docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md
      - docs/explanation/design/one-folder-two-independent-readers.md
---

# One module folder has two independent readers: the diagram described

```text
A 1572 x 722 diagram, read left to right from a tall code unit into two bands.
Glyphs: 4 code units (slate), 1 file (olive), 2 named sets (mauve), 1 ADR-only; 8 edges; 8 markers.
Sidebar: world-map grid (4 lit cells), tree (6 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/one-folder-two-independent-readers.md).

## At a glance

A 1572 × 722 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right. A tall code unit
stands outside the bands on the far left, and two full-width bands sit to its right: VISIBILITY (short, on top) and ASPECTS (tall, below).
It holds eight glyphs (four code units, one file, two named sets and one ADR-only) joined by eight edges, with eight markers and a legend
panel along the bottom. The eye lands first on the tall code unit on the left.

## Reading path

1. Marker 1, left of the bands: the code unit automation/&lt;Module&gt;/.
2. Right along the top edge into VISIBILITY: marker 2, the code unit Catzc.Internal.Bootstrap, then marker 3, the file &lt;Module&gt;.psd1.
3. Back to the left, along the lower edge into ASPECTS: marker 4, the code unit Catzc.Base.Variants, with an edge down to marker 5, the tall
   code unit Catzc.Base.Globs.
4. Right along two thick edges: marker 6, the named set &lt;module&gt;-live, above marker 7, the named set &lt;module&gt;-tests.
5. Right along two dashed edges to marker 8, the ADR-only glyph aspect sha locks.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                            |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 4     | automation/&lt;Module&gt;/ (far left, outside the bands), Catzc.Internal.Bootstrap (VISIBILITY), Catzc.Base.Variants and Catzc.Base.Globs (ASPECTS, left column) |
| file                  | 1     | &lt;Module&gt;.psd1 (VISIBILITY, right of Bootstrap)                                                                                                             |
| named set             | 2     | &lt;module&gt;-live above &lt;module&gt;-tests (ASPECTS, middle column)                                                                                          |
| ADR-only              | 1     | aspect sha locks (ASPECTS, right column; dashed white box, as tall as Globs)                                                                                     |

Code units are slate, the file is olive and the named sets are mauve, all with white names.

## Edges

| Edge kind              | Count | From → to                                                                                                                                                                     |
| ---------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow                   | 4     | automation/&lt;Module&gt;/ → Catzc.Internal.Bootstrap, Bootstrap → &lt;Module&gt;.psd1, automation/&lt;Module&gt;/ → Catzc.Base.Globs, Catzc.Base.Variants → Catzc.Base.Globs |
| thick (to a named set) | 2     | Catzc.Base.Globs → &lt;module&gt;-live, Catzc.Base.Globs → &lt;module&gt;-tests                                                                                               |
| ADR-only               | 2     | &lt;module&gt;-live → aspect sha locks, &lt;module&gt;-tests → aspect sha locks                                                                                               |

Seven edges are straight and horizontal, pointing right; the Variants → Globs edge points straight down. None crosses another, and none
carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in four columns of two rows, left to right:

| Swatch                    | Phrase                     |
| ------------------------- | -------------------------- |
| slate rounded box         | code unit                  |
| olive page, folded corner | file                       |
| mauve rounded box         | named set                  |
| dashed white box          | ADR-only                   |
| thin arrow                | flow: reads, then derives  |
| thick arrow               | thick: to a named set      |
| dashed arrow              | ADR-only (no code)         |
| dark disc `1`             | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md),
[tree](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md) and
[value-chain map](adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-DSGN-ASPECT); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-DSGN-ASPECT);
  `automation × .ps1` (5 files: 5 cite ADR-DSGN-ASPECT); `automation × .yml` (2 files: 2 cite ADR-DSGN-ASPECT); `docs × .md` (3 files: 2
  cite ADR-DSGN-ASPECT; 1 is the ADR file of ADR-DSGN-ASPECT).
- **Tree** (the repository's files): 6 lit groups, `Globs` (4 files); `Variants` (4 files); `adr/dsgn` (2 files); `Docs` (1 file);
  `QualityGates` (1 file); `adr/*` (1 file). The ADR file `docs/adr/design/module-aspects.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-ASPECT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-ASPECT: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
