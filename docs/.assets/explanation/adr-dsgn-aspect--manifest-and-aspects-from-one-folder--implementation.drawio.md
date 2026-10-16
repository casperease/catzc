---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: e210720832ca
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md
      - docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.png
      - docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md
      - docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.tree.md
      - docs/explanation/design/manifest-and-aspects-from-one-folder.md
---

# The manifest and the aspects both come from one folder: the diagram described

```text
A 1572 x 722 diagram, read left to right from a tall code unit into two bands.
Glyphs: 4 code units (slate), 1 gate, 2 files (olive), 2 named sets (mauve); 8 edges; 9 markers.
Sidebar: world-map grid (4 lit cells), tree (6 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/design/manifest-and-aspects-from-one-folder.md).

## At a glance

A 1572 × 722 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right. A tall code unit
stands outside the bands on the far left, and two full-width bands sit to its right: EVERY IMPORT (short, on top) and DERIVED SETS (tall,
below). It holds nine glyphs (four code units, one gate, two files and two named sets) joined by eight edges, with nine markers and a legend
panel along the bottom. The eye lands first on the tall code unit on the left.

## Reading path

1. Marker 1, left of the bands: the code unit automation/&lt;Module&gt;/.
2. Right along the top edge through EVERY IMPORT: marker 2, the gate Assert-Unique…FunctionName; marker 3, the code unit
   New-DynamicManifest; marker 4, the file &lt;Module&gt;.psd1.
3. DERIVED SETS, top row: marker 5, the file variants.yml, then marker 6, the code unit Get-Aspect.
4. Down from Get-Aspect to marker 7, the tall code unit AspectPartition.Compile, which also receives the long edge from the folder.
5. Right along two thick edges: marker 8, the named set &lt;kebab&gt;-live, above marker 9, the named set &lt;kebab&gt;-tests.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                   |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 4     | automation/&lt;Module&gt;/ (far left), New-DynamicManifest (EVERY IMPORT, centre), Get-Aspect and AspectPartition.Compile (DERIVED SETS, centre column) |
| gate                  | 1     | Assert-Unique…FunctionName (EVERY IMPORT, left; grey rhombus with a 3 px rim)                                                                           |
| file                  | 2     | &lt;Module&gt;.psd1 (EVERY IMPORT, right), variants.yml (DERIVED SETS, top left)                                                                        |
| named set             | 2     | &lt;kebab&gt;-live above &lt;kebab&gt;-tests (DERIVED SETS, right column)                                                                               |

Code units are slate, files olive and named sets mauve, all with white names; the gate is grey with dark text.

## Edges

| Edge kind              | Count | From → to                                                                                                                                                                                                                  |
| ---------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow                   | 6     | automation/&lt;Module&gt;/ → Assert-Unique…FunctionName → New-DynamicManifest → &lt;Module&gt;.psd1; variants.yml → Get-Aspect; Get-Aspect → AspectPartition.Compile; automation/&lt;Module&gt;/ → AspectPartition.Compile |
| thick (to a named set) | 2     | AspectPartition.Compile → &lt;kebab&gt;-live, AspectPartition.Compile → &lt;kebab&gt;-tests                                                                                                                                |

Seven edges are straight and horizontal, pointing right; the Get-Aspect → Compile edge points straight down. None crosses another, and none
carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                     |
| ------------------------- | -------------------------- |
| slate rounded box         | code unit                  |
| grey rhombus, thick rim   | gate                       |
| olive page, folded corner | file                       |
| mauve rounded box         | named set                  |
| thin arrow                | flow: call order           |
| thick arrow               | thick: to a named set      |
| dark disc `1`             | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md),
[tree](adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.tree.md) and
[value-chain map](adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-DSGN-ASPECT); the explanation articles, these descriptions and the drawing tooling never light
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
- **Lens badge:** IMPL, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
