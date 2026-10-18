# A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription: the diagram described

```text
A 1572 x 850 diagram, read top to bottom through five bands.
Glyphs: 2 code units, 1 runner (both slate), 2 results, 2 failures; 4 flow edges, 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](same-deploy-bicep-on-both-sides.md).

## At a glance

A 1572 × 850 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through five
full-width bands, labelled CONSUMERS, CLI SURFACE, CATZC, DELEGATED and VENDOR SUBSTRATE. It holds seven glyphs (two code units, one runner,
two results and two failures). Two flow edges enter the wide code unit Deploy-Bicep from above, and four edges leave it downward: two flow
edges to the results and two red failure paths to the failures. Seven markers and a legend panel along the bottom complete it. The eye lands
first on Deploy-Bicep, which spans most of the CLI SURFACE band.

## Reading path

1. Markers 1 and 2, CONSUMERS band: the code unit Connect-AzCli (left) and the runner Mode: azcli (right), each with an edge down.
2. Marker 3, CLI SURFACE band: the code unit Deploy-Bicep.
3. Marker 4, CATZC band, right: the failure subscription target rejected, at the end of a red failure path.
4. Markers 5 and 6, DELEGATED band: the result what-if preview (left) and the failure … failed (az exited N) (right of centre).
5. Marker 7, VENDOR SUBSTRATE band: the result Deployment … succeeded, at the end of the long centre edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                    |
| --------------------- | ----- | ------------------------------------------------------------------------ |
| code unit             | 2     | Connect-AzCli (CONSUMERS), Deploy-Bicep (CLI SURFACE)                    |
| runner                | 1     | Mode: azcli (CONSUMERS)                                                  |
| result                | 2     | what-if preview (DELEGATED), Deployment … succeeded (VENDOR SUBSTRATE)   |
| failure               | 2     | subscription target rejected (CATZC), … failed (az exited N) (DELEGATED) |

The code units (rounded boxes) and the runner (a pill) are slate with white names; the results are light green and the failures light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                       |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | Connect-AzCli → Deploy-Bicep, Mode: azcli → Deploy-Bicep, Deploy-Bicep → what-if preview, Deploy-Bicep → Deployment … succeeded |
| failure path | 2     | Deploy-Bicep → subscription target rejected, Deploy-Bicep → … failed (az exited N)                                              |

Every edge is straight and vertical, and none crosses another or a glyph.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| slate pill              | runner                     |
| light-green rounded box | result                     |
| light-red rounded box   | failure                    |
| grey arrow              | flow: then                 |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one layer            |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-THINPLAT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md),
[tree](../.assets/tree/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-THINPLAT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
