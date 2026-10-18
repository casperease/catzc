# Catzc.Base.Globs owns the check, the loader names the context, and git names the change: the diagram described

```text
A 1572 x 680 diagram, read top to bottom from a module band into two bands below it, with a caller band to the right.
Glyphs: 5 code units (slate), 1 file (olive), 1 external tool (neutral), 1 ADR-only; 6 flow edges, 1 ADR-only edge; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture.drawio.png)
draws, in the vocabulary of the diagram glyphs; what it means is in [the article](globs-asks-loader-for-context-and-git-for-diff.md).

## At a glance

A 1572 × 680 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has four bands: a large band
`CATZC.BASE.GLOBS` on the upper left, a band `PIPELINE` on the upper right, and two bands side by side below the first,
`CATZC.INTERNAL.LOADER` and `OUTSIDE CATS`. It holds eight glyphs, five code units, a file, an external tool and an ADR-only, joined by six
flow edges and one ADR-only edge, with eight markers and a legend panel along the bottom. The eye lands first on the wide code unit at the
top of the module band, which the dashed edge from the right enters.

## Reading path

1. Marker 1, `PIPELINE` band: the ADR-only glyph a unit's pipeline stage, dashed.
2. Left along the dashed ADR-only edge to marker 2, `CATZC.BASE.GLOBS` band: the wide code unit Test-GlobSetAffected.
3. Left along a flow edge to marker 3: the file globs.yml.
4. Down the left flow edge to marker 4: the code unit Get-GlobSetChangeRange; down again, out of the band, to marker 5,
   `CATZC.INTERNAL.LOADER` band: the code unit Test-IsRunningInPipeline.
5. Down the right flow edge to marker 6: the code unit Get-ChangedGlobSet; down to marker 7: the code unit Get-ChangedFile; down again, out
   of the band, to marker 8, `OUTSIDE CATS` band: the external tool git.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                      |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | Test-GlobSetAffected, Get-GlobSetChangeRange, Get-ChangedGlobSet, Get-ChangedFile (`CATZC.BASE.GLOBS`); Test-IsRunningInPipeline (`CATZC.INTERNAL.LOADER`) |
| file                  | 1     | globs.yml (`CATZC.BASE.GLOBS`, top left)                                                                                                                   |
| external tool         | 1     | git (`OUTSIDE CATS`)                                                                                                                                       |
| ADR-only              | 1     | a unit's pipeline stage (`PIPELINE`), dashed pill                                                                                                          |

Code units are slate and the file olive, both with white names; the external tool is a neutral square box and the ADR-only glyph a dashed
outline on the page.

## Edges

| Edge kind          | Count | From → to                                                                                                                                                                                                                                  |
| ------------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow: asks         | 6     | Test-GlobSetAffected → globs.yml; Test-GlobSetAffected → Get-GlobSetChangeRange; Test-GlobSetAffected → Get-ChangedGlobSet; Get-GlobSetChangeRange → Test-IsRunningInPipeline; Get-ChangedGlobSet → Get-ChangedFile; Get-ChangedFile → git |
| ADR-only (no code) | 1     | a unit's pipeline stage → Test-GlobSetAffected, dashed                                                                                                                                                                                     |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch             | Phrase                     |
| ------------------ | -------------------------- |
| slate rounded box  | code unit                  |
| olive page         | file                       |
| neutral square box | external tool              |
| dashed outline     | ADR-only                   |
| thin arrow         | flow: asks                 |
| dashed arrow       | ADR-only (no code)         |
| light disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-DETECT and ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--globs-asks-loader-for-context-and-git-for-diff--architecture.chain.md), which hold the
reason for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-DETECT and ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
