---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/design/a-push-fires-only-touched-pipelines.drawio.md
    folder: docs/explanation/design
    name: a-push-fires-only-touched-pipelines-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md
      - docs/explanation/design/a-push-fires-only-touched-pipelines.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# A push starts only the pipelines whose globset it touches: the diagram described

```text
A 1572 x 740 diagram, read left to right through three bands above a full-width band.
Glyphs: 3 named sets (mauve), 3 runners (slate), 1 gate, 1 failure; 5 edges; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](a-push-fires-only-touched-pipelines.md).

## At a glance

A 1572 × 740 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three side-by-side bands read left to right,
labelled YOU CHANGE, DEPLOYABLE-UNITS and PIPELINES, above a full-width band labelled TRIGGER DRIFT. It holds eight glyphs (three named
sets, three runners, one gate and one failure) joined by five edges, with seven markers and a legend panel along the bottom. The eye lands
first on the tall named set in the YOU CHANGE band.

## Reading path

1. Marker 1, YOU CHANGE band, top: the named set automation/\*\*, with a long edge right to marker 2, the runner ci-automation.
2. Marker 3, PIPELINES band, middle: the runner ci-infrastructure, reached by a long edge from the tall named set infrastructure/\*\*.
3. Marker 4, just below the thick edge from infrastructure/\*\* to the named set nova · apex · flux · shared.
4. Marker 5, PIPELINES band, bottom: the runner cd-&lt;unit&gt;.
5. Markers 6 and 7, TRIGGER DRIFT band: the gate Test-AdoPipelineTriggerGlob and, along a red edge to its right, the failure trigger
   drifted.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                      |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------- |
| named set             | 3     | automation/\*\*, infrastructure/\*\* (YOU CHANGE, the second tall); nova · apex · flux · shared (DEPLOYABLE-UNITS, bottom) |
| runner                | 3     | ci-automation, ci-infrastructure, cd-&lt;unit&gt; (PIPELINES, one per row)                                                 |
| gate                  | 1     | Test-AdoPipelineTriggerGlob (TRIGGER DRIFT, centre right)                                                                  |
| failure               | 1     | trigger drifted (TRIGGER DRIFT, right)                                                                                     |

Named sets are mauve and runners slate, both with white names; the gate is a grey rhombus with a thick rim, the failure red.

## Edges

| Edge kind    | Count | From → to                                                                                                               |
| ------------ | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| flow         | 3     | automation/\*\* → ci-automation, infrastructure/\*\* → ci-infrastructure, nova · apex · flux · shared → cd-&lt;unit&gt; |
| thick        | 1     | infrastructure/\*\* → nova · apex · flux · shared (marker 4)                                                            |
| failure path | 1     | Test-AdoPipelineTriggerGlob → trigger drifted                                                                           |

Every edge is straight and horizontal, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                              |
| ----------------------- | ----------------------------------- |
| mauve rounded box       | named set                           |
| slate pill              | runner                              |
| grey rhombus, thick rim | gate                                |
| red rounded box         | failure                             |
| thin arrow              | flow: a change here fires the next  |
| thick arrow             | thick: a change re-keys a named set |
| red arrow               | failure path                        |
| dark disc `1`           | marker: a Walkthrough step          |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-TRACK): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md),
[tree](../.assets/tree/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
