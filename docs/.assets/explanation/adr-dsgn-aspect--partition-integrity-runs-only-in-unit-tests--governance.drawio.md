# docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md

`Partition integrity runs only in unit tests: the diagram described`

```text
A 1572 x 602 diagram, read left to right through four column bands.
Glyphs: 4 gates, 2 code units (slate), 2 ADR-only; 6 edges; 11 rule chips; 8 markers.
Sidebar: axis minimap (main cell DSGN x BUILD), tree minimap, lens badge GOV, map key.
```

This describes what the [diagram](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/design/partition-integrity-runs-only-in-unit-tests.md).

## At a glance

A 1572 × 602 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
column bands, labelled FOLDER, VISIBILITY, ASPECT and SHA LOCK. It holds eight glyphs (four gates, two code units and two ADR-only) joined
by six edges, with eleven rule chips, eight markers and a legend panel along the bottom. The eye lands first on the wide code unit across
the top of FOLDER.

## Reading path

1. Marker 1, FOLDER, top: the wide code unit automation/&lt;Module&gt;/.
2. Down two edges to markers 2 and 3, FOLDER, bottom row: the gates Test-SourceConventions and Test-FolderConventions.
3. Right along the edge from the code unit into VISIBILITY: marker 4, the gate Assert-Unique…FunctionName, then down to marker 5, the code
   unit New-DynamicManifest.
4. ASPECT: marker 6, the gate VariantsConfig, with a dashed edge down to marker 7, the ADR-only gate AspectPartition.Validate.
5. Right along a dashed edge to marker 8, SHA LOCK: the ADR-only glyph aspect sha lock.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                           |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| gate                  | 4     | Test-SourceConventions and Test-FolderConventions (FOLDER, bottom row), Assert-Unique…FunctionName (VISIBILITY, top), VariantsConfig (ASPECT, top); grey rhombi with a 3 px rim |
| code unit             | 2     | automation/&lt;Module&gt;/ (FOLDER, top, band-wide), New-DynamicManifest (VISIBILITY, bottom)                                                                                   |
| ADR-only              | 2     | AspectPartition.Validate (ASPECT, bottom; a white dashed rhombus inside a dashed frame), aspect sha lock (SHA LOCK, top; a dashed white box)                                    |

Code units are slate with white names; the gates are grey with dark text.

## Edges

| Edge kind | Count | From → to                                                                                                                                                     |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | automation/&lt;Module&gt;/ → Test-SourceConventions, → Test-FolderConventions, → Assert-Unique…FunctionName; Assert-Unique…FunctionName → New-DynamicManifest |
| ADR-only  | 2     | VariantsConfig → AspectPartition.Validate, VariantsConfig → aspect sha lock                                                                                   |

Every edge is straight; three point down and three point right. None crosses another, and none carries a label.

**Rule chips.** Eleven small white pills beside their glyphs: O1 and M4 above-right of Test-SourceConventions; F6 above-right of
Test-FolderConventions; M4 right of Assert-Unique…FunctionName; M2 and M3 right of New-DynamicManifest; A2 and A3 below-right of
VariantsConfig; A5 right of AspectPartition.Validate; A4 and G9 right of aspect sha lock.

## Legend

A full-width panel at the bottom of the drawing area, in three rows, left to right:

| Swatch                  | Phrase                                                                                                             |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------ |
| grey rhombus, thick rim | gate                                                                                                               |
| slate rounded box       | code unit                                                                                                          |
| dashed white box        | ADR-only (a gate: dashed rhombus in a dashed frame)                                                                |
| thin arrow              | flow: reads, then runs                                                                                             |
| dashed arrow            | ADR-only (no code)                                                                                                 |
| dark disc `1`           | marker: a Walkthrough step                                                                                         |
| white chip `#3`         | rule chip: O ADR-PWSH-ONEFUNC · F ADR-REPO-FOLDERS · M ADR-PWSH-MANIFEST · A ADR-DSGN-ASPECT · G ADR-FLOW-CD-GLOBS |

## Sidebar

- **Axis minimap:** the main cell is DSGN × BUILD, framed and filled in the BUILD purple with the you-are-here dot. Five touched cells carry
  a small grey dot: AUTO × LOAD, AUTO × CONFIG, AUTO × GLOBS, AUTO × BUILD and PIPE × GLOBS. The DSGN and BUILD axis labels carry a purple
  tick.
- **Tree minimap:** lit tiles labelled QualityGates, ModuleSystem, Globs, Variants, internal, adr/auto, adr/repo and adr/flow, the ADR files
  framed in dark ink.
- **Lens badge:** GOV. Beneath it, three tight lines: "Supports ADR-DSGN-ASPECT", "ADR-PWSH-MANIFEST · ADR-PWSH-ONEFUNC" and
  "ADR-REPO-FOLDERS · ADR-FLOW-CD-GLOBS".
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
