---
catzc:
  immutable:
    with_body_sha: "8b763afa2d5b"
    path: docs/.assets/explanation/adr-dsgn-aspect--get-aspect-names-the-remainder--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-aspect-get-aspect-names-the-remainder-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-aspect--get-aspect-names-the-remainder--operations.drawio.png
      - docs/explanation/design/get-aspect-names-the-remainder.md
---

# Get-Aspect names the remainder: the diagram described

```text
A 1572 x 654 diagram, read top to bottom from one wide file into two side-by-side column bands, with a failure beside the file.
Glyphs: 1 file (olive), 2 code units (slate), 4 named sets (mauve), 1 failure; 2 flow edges, 4 thick edges, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-dsgn-aspect--get-aspect-names-the-remainder--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/get-aspect-names-the-remainder.md).

## At a glance

A 1572 × 654 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. A wide file
glyph spans most of the top, with a failure to its right, and below them two column bands sit side by side, labelled `AUTOMATION` on the
left and `INFRASTRUCTURE` on the right. Each band stacks a code unit above two named sets. Seven edges join the glyphs, eight markers number
them, and a legend panel runs along the bottom. The eye lands first on the red failure at the top right.

## Reading path

1. Marker 1, top: the wide file variants.yml; right along the failure path to marker 2, the failure the last aspect must be '**'.
2. Down the left flow edge into the left band: marker 3, the code unit Get-Aspect -Track automation; then down two thick edges to marker 4,
   the named set live, and marker 5, the named set tests.
3. Down the right flow edge into the right band: marker 6, the code unit Get-Aspect…infrastructure; then down two thick edges to marker 7,
   the named set tests, and marker 8, the named set live.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                         |
| --------------------- | ----- | --------------------------------------------------------------------------------------------- |
| file                  | 1     | variants.yml (top, spanning both columns)                                                     |
| code unit             | 2     | Get-Aspect -Track automation (left band, top), Get-Aspect…infrastructure (right band, top)    |
| named set             | 4     | live and tests (left band, middle and bottom), tests and live (right band, middle and bottom) |
| failure               | 1     | the last aspect must be '**' (top right, beside the file)                                     |

The file is olive, the code units slate and the named sets mauve, all with white names; the failure is red with a pale name. The right
band's code unit name is elided in the middle; the article gives it in full.

## Edges

| Edge kind              | Count | From → to                                                                                          |
| ---------------------- | ----- | -------------------------------------------------------------------------------------------------- |
| flow                   | 2     | variants.yml → Get-Aspect -Track automation; variants.yml → Get-Aspect…infrastructure              |
| thick (to a named set) | 4     | Get-Aspect -Track automation → live, live → tests; Get-Aspect…infrastructure → tests, tests → live |
| failure path           | 1     | variants.yml → the last aspect must be '**'                                                        |

The failure path is horizontal, pointing right, from the file's right edge; the other six edges are vertical, pointing down, and the two
that leave the file start at its lower edge above each column's centre. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in two rows of four, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| olive folded page | file                              |
| slate rounded box | code unit                         |
| mauve rounded box | named set                         |
| red rounded box   | failure                           |
| thin arrow        | flow: feeds                       |
| thick arrow       | to a named set: returned in order |
| red arrow         | failure path                      |
| light disc `1`    | marker: a Walkthrough step        |

## Sidebar

The lens badge reads OPS. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
