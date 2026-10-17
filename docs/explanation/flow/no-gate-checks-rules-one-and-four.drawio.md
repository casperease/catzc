---
catzc:
  immutable:
    with_body_sha: "0c0dd3552a1f"
    repo_status: clean
    path: docs/explanation/flow/no-gate-checks-rules-one-and-four.drawio.md
    folder: docs/explanation/flow
    name: no-gate-checks-rules-one-and-four-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md
      - docs/explanation/flow/no-gate-checks-rules-one-and-four.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# No gate checks the runner rules 1 or 4: the diagram described

```text
A 1572 x 600 diagram: a row of four glyphs above a row of three gates, each gate's edge rising to the glyph above it.
Glyphs: 1 file (olive), 1 code unit (slate), 2 ADR-only, 3 gates; 3 flow edges; 5 rule chips (2 dashed); 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](no-gate-checks-rules-one-and-four.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, RULES above
and GATES below. The RULES band holds four glyphs left to right, with no edges between them: one file, one code unit and two ADR-only glyphs
(a dashed page and a dashed rounded box). The GATES band holds three gates, each sending one edge straight up into the band above. Three
edges, five rule chips (two of them dashed), seven markers and a legend panel along the bottom. The eye lands first on the three wide grey
rhombi.

## Reading path

1. Marker 1, RULES band: the ADR-only page pipeline YAML (dashed outline, white), dashed rule chip R1.
2. Right to marker 2, the file step template, rule chip R3.
3. Right to marker 3, the code unit runner, rule chip R2.
4. Right to marker 4, the ADR-only box same RunCommand (dashed outline, white), dashed rule chip R4.
5. Down to the GATES band, left to right: marker 5, the gate Test-Pipelines with rule chip N4; marker 6, the gate expected-failures 1b;
   marker 7, the gate expected-failures · Pester.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                        |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------ |
| file                  | 1     | step template (RULES band, second)                                                                           |
| code unit             | 1     | runner (RULES band, third)                                                                                   |
| ADR-only              | 2     | pipeline YAML (a file's page shape), same RunCommand (a code unit's rounded box); RULES band, first and last |
| gate                  | 3     | Test-Pipelines, expected-failures 1b, expected-failures · Pester (GATES band)                                |

The file is an olive page and the code unit a slate box, both with white names; the ADR-only glyphs are white with dashed rims.

## Edges

| Edge kind | Count | From → to                                                                                                 |
| --------- | ----- | --------------------------------------------------------------------------------------------------------- |
| flow      | 3     | Test-Pipelines → pipeline YAML, expected-failures 1b → step template, expected-failures · Pester → runner |

All three edges are vertical, from each rhombus's top vertex up to the bottom of the glyph above it. None crosses another. same RunCommand
has no gate below it, and no edge runs along the RULES band.

## Legend

A full-width panel at the bottom of the drawing area, in four columns and three rows, left to right:

| Swatch                  | Phrase                                               |
| ----------------------- | ---------------------------------------------------- |
| olive page              | file                                                 |
| slate rounded box       | code unit                                            |
| grey rhombus, thick rim | gate                                                 |
| white dashed box        | ADR-only                                             |
| thin arrow              | flow: checks                                         |
| white chip `R1`         | rule chip: R = ADR-FLOW-CD-RUNNER, N = ADR-PIPE-NAME |
| dashed chip `R1`        | dashed rule chip: ADR-only (no gate)                 |
| dark disc `1`           | marker: a Walkthrough step                           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md),
[tree](../.assets/tree/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-FLOW-CD-RUNNER and ADR-PIPE-NAME" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
