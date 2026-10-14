# docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md

`A pipeline step only names a command: the diagram described`

```text
A 1572 x 600 diagram, read left to right along one row, then up from a lower band.
Glyphs: 2 runners, 2 code units (slate), 1 actor; 3 flow edges, 1 ADR-only edge; 5 markers.
Sidebar: axis minimap (main cell PIPE x LOAD), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/a-step-only-names-a-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, PIPELINE
above and DEVELOPER below. It holds five glyphs (two runners, two code units and one actor) joined by four edges, with five markers and a
legend panel along the bottom. The eye lands first on the two slate pills at the left of the PIPELINE band.

## Reading path

1. Marker 1, PIPELINE band: the runner pipeline step, at the left edge.
2. Right to marker 2, the runner pipeline task.
3. Right to marker 3, the code unit runner.
4. A long edge right to marker 4, the code unit same command, at the right edge.
5. Marker 5, DEVELOPER band: the actor developer, whose dashed edge rises to same command.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                     |
| --------------------- | ----- | --------------------------------------------------------- |
| runner                | 2     | pipeline step, pipeline task (PIPELINE band, left)        |
| code unit             | 2     | runner (PIPELINE band, centre left), same command (right) |
| actor                 | 1     | developer (DEVELOPER band, under same command)            |

Runners and code units are slate with white names; the pill shape tells a runner from a code unit's rounded box.

## Edges

| Edge kind | Count | From → to                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------- |
| flow      | 3     | pipeline step → pipeline task, pipeline task → runner, runner → same command |
| ADR-only  | 1     | developer → same command                                                     |

The flow edges are horizontal along one row; the ADR-only edge is vertical and dashed. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| slate pill        | runner                      |
| slate rounded box | code unit                   |
| white circle      | actor                       |
| thin arrow        | flow: passes the command on |
| dashed arrow      | ADR-only (no code)          |
| dark disc `1`     | marker: a Walkthrough step  |

## Sidebar

- **Axis minimap:** the main cell is PIPE × LOAD, framed and filled in the LOAD indigo with the you-are-here dot. One touched cell,
  PIPE × BUILD, carries a small grey dot. The PIPE and LOAD axis labels carry an indigo tick.
- **Tree minimap:** lit tiles labelled adr/flow and pipelines.
- **Lens badge:** META, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
