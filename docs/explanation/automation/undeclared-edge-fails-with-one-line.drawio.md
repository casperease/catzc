---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/automation/undeclared-edge-fails-with-one-line.drawio.md
    folder: docs/explanation/automation
    name: undeclared-edge-fails-with-one-line-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.png
      - docs/explanation/.assets/chain/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md
      - docs/explanation/.assets/grid/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md
      - docs/explanation/.assets/tree/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md
      - docs/explanation/automation/undeclared-edge-fails-with-one-line.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# An undeclared edge fails with one line: the diagram described

```text
A 1572 x 640 diagram, read top to bottom through three bands and left to right within each.
Glyphs: 2 runners (slate), 1 result, 2 failures, 1 file (olive); 3 flow edges, 2 failure paths; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](undeclared-edge-fails-with-one-line.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled RUN, SEE and FIX, and left to right within each. It holds six glyphs, two runners, one result, two failures and
one file, joined by three flow edges and two failure paths, with six markers and a legend panel along the bottom. The eye lands first on the
two red failures stacked on the right.

## Reading path

1. Marker 1, RUN band, left: the runner Test-Automation.
2. Right to marker 2: the runner Test-ModuleDependency.
3. Right along the failure path to marker 3: the failure Bad dependencies.yml.
4. Down from marker 2 to marker 4, SEE band: the result module-dependency.md.
5. Right along the failure path to marker 5: the failure failed: N issue(s).
6. Down to marker 6, FIX band, right: the file dependencies.yml.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                        |
| --------------------- | ----- | ---------------------------------------------------------------------------- |
| runner                | 2     | Test-Automation (RUN band, left), Test-ModuleDependency (RUN band, centre)   |
| result                | 1     | module-dependency.md (SEE band, centre)                                      |
| failure               | 2     | Bad dependencies.yml (RUN band, right), failed: N issue(s) (SEE band, right) |
| file                  | 1     | dependencies.yml (FIX band, right)                                           |

Runners are slate pills and the file is olive, both with white names; the result is light green and the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                    |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------- |
| flow         | 3     | Test-Automation → Test-ModuleDependency, Test-ModuleDependency → module-dependency.md, failed: N issue(s) → dependencies.yml |
| failure path | 2     | Test-ModuleDependency → Bad dependencies.yml, module-dependency.md → failed: N issue(s)                                      |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate pill              | runner                     |
| light green rounded box | result                     |
| light red rounded box   | failure                    |
| olive folded page       | file                       |
| thin arrow              | flow: then                 |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one stage            |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEPM): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md),
[tree](../.assets/tree/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md) and
[value-chain map](../.assets/chain/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
