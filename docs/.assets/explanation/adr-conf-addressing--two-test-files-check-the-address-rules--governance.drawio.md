---
catzc:
  derived:
    path: docs/.assets/explanation/adr-conf-addressing--two-test-files-check-the-address-rules--governance.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "1f468b4b3f2b"
    links:
      - docs/.assets/explanation/adr-conf-addressing--two-test-files-check-the-address-rules--governance.drawio.png
      - docs/explanation/configuration/two-test-files-check-the-address-rules.md
---

# Two test files check the address rules: the diagram described

```text
A 1572 x 660 diagram, read left to right along two bands side by side, with a band of gates below pointing up.
Glyphs: 4 code units (slate), 1 ADR-only box, 2 gates; 5 flow edges; 7 markers; 12 rule chips.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-conf-addressing--two-test-files-check-the-address-rules--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/configuration/two-test-files-check-the-address-rules.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along two bands
side by side, `RESOLVE` on the left and `SECRETS` on the right, and down into a full-width band labelled `L0 TESTS` whose two gates point
up. It holds seven glyphs, four code units, one ADR-only box and two gates, joined by five flow edges, with seven markers, twelve rule chips
and a legend panel along the bottom. The eye lands first on the dashed ADR-only box at the right end of the `RESOLVE` band.

## Reading path

1. Markers 1, 2 and 3, `RESOLVE` band, left to right: the code units address grammar, one reader and key walk, inside a frame.
2. Marker 4, at the right end of the band: the ADR-only box a read, not a copy.
3. Marker 5, `SECRETS` band: the code unit secret hand-off.
4. Marker 6, `L0 TESTS` band, left: the gate Get-ConfigValue.Tests, whose edge runs up into the frame.
5. Marker 7, `L0 TESTS` band, right: the gate Write-EnvironmentSet.Tests, whose edge runs up into secret hand-off.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                      |
| --------------------- | ----- | ------------------------------------------------------------------------------------------ |
| code unit             | 4     | address grammar, one reader, key walk (`RESOLVE`, in a frame); secret hand-off (`SECRETS`) |
| ADR-only              | 1     | a read, not a copy (`RESOLVE`, right end)                                                  |
| gate                  | 2     | Get-ConfigValue.Tests (`L0 TESTS`, left), Write-EnvironmentSet.Tests (`L0 TESTS`, right)   |

Code units are slate with white names; the ADR-only box is the page colour with a dashed rim; the gates are neutral rhombi with a 3 px rim.
The frame is chrome: a thin rim with no fill.

Rule chips sit on the top-right of each glyph: `A1 A2` on address grammar, `A1` and a dashed `A3` on one reader, `A2 A4` on key walk, a
dashed `A5` on a read, not a copy, `E7` on secret hand-off, `A1 A2 A4` on Get-ConfigValue.Tests and `E7` on Write-EnvironmentSet.Tests.

## Edges

| Edge kind | Count | From → to                                                                                                                                                           |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | address grammar → one reader, one reader → key walk, key walk → a read, not a copy, Get-ConfigValue.Tests → the frame, Write-EnvironmentSet.Tests → secret hand-off |

Three edges are horizontal and two run straight up. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                 |
| ----------------- | -------------------------------------- |
| slate rounded box | code unit                              |
| neutral rhombus   | gate                                   |
| dashed box        | ADR-only                               |
| thin arrow        | flow: the walk, or what a test checks  |
| chip `A1`         | rule chip: A ADDRESSING, E AUTO-ENVVAR |
| dashed chip `A5`  | dashed rule chip: ADR-only (no gate)   |
| light disc `1`    | marker: a Walkthrough step             |

## Sidebar

The lens badge reads `GOV`. The three minimaps sit above it, and the map key below it names the four swatches.
