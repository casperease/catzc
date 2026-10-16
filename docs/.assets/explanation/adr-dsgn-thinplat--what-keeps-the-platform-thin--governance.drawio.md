---
catzc:
  immutable:
    with_body_sha: a19eb7f2ba2e
    path: docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-thinplat-what-keeps-the-platform-thin-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.png
      - docs/.assets/explanation/chain/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
      - docs/.assets/explanation/grid/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
      - docs/.assets/explanation/tree/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md
      - docs/explanation/design/what-keeps-the-platform-thin.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Three gates guard the CLI and az: the diagram described

```text
A 1572 x 800 diagram, read top to bottom through four bands.
Glyphs: 3 gates, 3 ADR-only gates, 1 code unit (slate), 1 external tool; 3 flow and 3 ADR-only edges.
Marks: 8 rule chips, 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/what-keeps-the-platform-thin.md).

## At a glance

A 1572 × 800 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled CLI SURFACE, CATZC, DELEGATED and VENDOR SUBSTRATE. It holds eight glyphs: three gates, three ADR-only gates
(white rhombi, each inside a dashed frame), one code unit and one external tool. Six edges join them, all pointing into the code unit or the
external tool. Every glyph carries a rule chip and a marker, and a legend panel runs along the bottom. The eye lands first on the wide slate
code unit in the top band, between two gates.

## Reading path

1. Marker 1, CLI SURFACE band, left: the gate NoAzModuleNaming, with an edge right into marker 2.
2. Marker 2, centre: the code unit Verb-Noun functions.
3. Marker 3, right: the gate config validation, with an edge left into marker 2.
4. Marker 4, CATZC band: the ADR-only gate everything is code, with a dashed edge up into marker 2.
5. Marker 5, CATZC band: the gate Assert-Tool 'az_cli', with an edge down into marker 7.
6. Marker 6, DELEGATED band, left: the ADR-only gate no reimplementation, with a dashed edge right into marker 7.
7. Marker 7, centre: the external tool az CLI.
8. Marker 8, VENDOR SUBSTRATE band: the ADR-only gate swappable substrate, with a dashed edge up into marker 7.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                               |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------- |
| gate                  | 3     | NoAzModuleNaming and config validation (CLI SURFACE), Assert-Tool 'az_cli' (CATZC)                  |
| ADR-only              | 3     | everything is code (CATZC), no reimplementation (DELEGATED), swappable substrate (VENDOR SUBSTRATE) |
| code unit             | 1     | Verb-Noun functions (CLI SURFACE, centre)                                                           |
| external tool         | 1     | az CLI (DELEGATED, centre)                                                                          |

The code unit is slate with a white name; the gates and the external tool are neutral grey, the ADR-only gates white.

## Edges

| Edge kind | Count | From → to                                                                                                      |
| --------- | ----- | -------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | NoAzModuleNaming → Verb-Noun functions, config validation → Verb-Noun functions, Assert-Tool 'az_cli' → az CLI |
| ADR-only  | 3     | everything is code → Verb-Noun functions, no reimplementation → az CLI, swappable substrate → az CLI           |

Every edge is straight, horizontal or vertical, and none crosses another. The eight rule chips read A3, T3, T1, T4, A2, T2, A1 and T5 in
marker order, each on its glyph's top-right corner.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                           |
| ----------------------- | -------------------------------- |
| grey rhombus, thick rim | gate                             |
| white rhombus           | ADR-only                         |
| slate rounded box       | code unit                        |
| grey square box         | external tool                    |
| grey arrow              | flow: guards                     |
| dashed grey arrow       | ADR-only (no code): guards       |
| white chip `T3`         | rule chip: T THINPLAT · A AZ-CLI |
| dark disc `1`           | marker: a Walkthrough step       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-CLI and ADR-DSGN-THINPLAT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md),
[tree](tree/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md) and
[value-chain map](chain/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AZ-CLI and ADR-DSGN-THINPLAT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
