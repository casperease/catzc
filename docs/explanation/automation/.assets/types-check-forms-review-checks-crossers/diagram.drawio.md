# Three types check path forms at construction, and the crossing rules are left to review: the diagram described

```text
A 1572 x 700 diagram, read left to right through three bands, then the band below.
Glyphs: 3 named sets (mauve), 1 code unit (slate), 3 gates, 1 ADR-only; 3 flow edges; 4 rule chips; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../types-check-forms-review-checks-crossers.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `COMMUNICATION FORM`, `THE TWO CROSSERS` and `BINDING FORM`, then down to one full-width band labelled `CROSS-STAGE`. It
holds eight glyphs, three named sets, one code unit, three gates and one ADR-only, joined by three flow edges, with four rule chips, eight
markers and a legend panel along the bottom. The eye lands first on the three grey rhombi.

## Reading path

1. Marker 1, `COMMUNICATION FORM` band, top: the named set Communication form, rule chip `#1 · #2 · #6 · #11` above its right end.
2. Marker 2, `THE TWO CROSSERS` band, top: the code unit The two crossers, dashed rule chip `#4 · #7 · #9`.
3. Marker 3, `BINDING FORM` band, top: the named set Binding form, dashed rule chip `#3`.
4. Markers 4 and 5, `COMMUNICATION FORM` band, bottom, left to right: the gates RepoRelativePath and InspirationRoot, each with a flow edge
   up into Communication form.
5. Marker 6, `THE TWO CROSSERS` band, bottom: the ADR-only glyph Code review, joined to nothing.
6. Down to marker 7, `CROSS-STAGE` band, left: the named set Published artifact, rule chip `#10`; and marker 8, to its right: the gate
   ArtifactRef, with a flow edge left into Published artifact.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                        |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------ |
| named set             | 3     | Communication form (`COMMUNICATION FORM`), Binding form (`BINDING FORM`), Published artifact (`CROSS-STAGE`) |
| code unit             | 1     | The two crossers (`THE TWO CROSSERS`, top)                                                                   |
| gate                  | 3     | RepoRelativePath and InspirationRoot (`COMMUNICATION FORM`, bottom), ArtifactRef (`CROSS-STAGE`), 3 px rims  |
| ADR-only              | 1     | Code review (`THE TWO CROSSERS`, bottom), dashed outline                                                     |

Named sets are mauve and the code unit slate, both with light names; the gates are grey rhombi and the ADR-only glyph is a dashed box.

## Edges

| Edge kind | Count | From → to                                                                                                     |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | RepoRelativePath → Communication form; InspirationRoot → Communication form; ArtifactRef → Published artifact |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a chip. Four rule chips sit above the right end of
the glyphs they govern: `#1 · #2 · #6 · #11` and `#10` are solid, `#4 · #7 · #9` and `#3` are dashed.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                               |
| ----------------------- | ------------------------------------ |
| mauve rounded box       | named set                            |
| slate rounded box       | code unit                            |
| grey rhombus, thick rim | gate: a type's construction check    |
| dashed box              | ADR-only                             |
| thin arrow              | flow: checks                         |
| light disc `1`          | marker: a Walkthrough step           |
| white chip `#2`         | rule chip: ADR-AUTO-PATH#n           |
| dashed chip `#3`        | dashed rule chip: ADR-only (no gate) |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-PATH): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-PATH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
