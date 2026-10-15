# docs/.assets/explanation/adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.drawio.md

`Callers in four modules share one resolver: the diagram described`

```text
A 1572 x 640 diagram, read left to right through three bands side by side.
Glyphs: 7 code units (slate), 1 file (olive); 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-conf-addressing--callers-in-four-modules-share-one-resolver--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/configuration/callers-in-four-modules-share-one-resolver.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled `CALLERS`, `CATZC.BASE.CONFIG` and `COMMITTED CONFIG`. It holds eight glyphs, seven code units and one file,
joined by four flow edges, with five markers and a legend panel along the bottom. The eye lands first on the frame of four stacked code
units in the left band.

## Reading path

1. Marker 1, `CALLERS` band: a frame around four code units stacked top to bottom, Catzc.Tooling.Environment, Catzc.Azure.Templates,
   Catzc.Base.Languages and Catzc.Base.QualityGates.
2. Right along the one edge that leaves the frame to marker 2, `CATZC.BASE.CONFIG` band: the code unit Get-ConfigValue.
3. Down to marker 3: the code unit Resolve-ConfigKeyPath, directly below Get-ConfigValue.
4. Right from Get-ConfigValue to marker 4: the code unit Get-Config.
5. Right to marker 5, `COMMITTED CONFIG` band: the file configs/&lt;name&gt;.yml.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 7     | Catzc.Tooling.Environment, Catzc.Azure.Templates, Catzc.Base.Languages, Catzc.Base.QualityGates (`CALLERS`, in a frame); Get-ConfigValue, Get-Config, Resolve-ConfigKeyPath (`CATZC.BASE.CONFIG`) |
| file                  | 1     | configs/&lt;name&gt;.yml (`COMMITTED CONFIG`)                                                                                                                                                     |

Code units are slate and the file is olive, all with white names. The frame is chrome: a thin rim with no fill.

## Edges

| Edge kind | Count | From → to                                                                                                                                          |
| --------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | the callers' frame → Get-ConfigValue, Get-ConfigValue → Get-Config, Get-ConfigValue → Resolve-ConfigKeyPath, Get-Config → configs/&lt;name&gt;.yml |

Every edge is straight; three are horizontal and one runs down. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in two columns, left to right:

| Swatch                    | Phrase                     |
| ------------------------- | -------------------------- |
| slate rounded box         | code unit                  |
| olive page, folded corner | file                       |
| thin arrow                | flow: depends on           |
| light disc `1`            | marker: a Walkthrough step |

## Sidebar

The lens badge reads `ARCH`. The three minimaps sit above it, and the map key below it names the four swatches.
