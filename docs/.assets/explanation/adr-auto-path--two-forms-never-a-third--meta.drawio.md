---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-path--two-forms-never-a-third--meta.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "66e15f5bbc4d"
    links:
      - docs/.assets/explanation/adr-auto-path--two-forms-never-a-third--meta.drawio.png
      - docs/explanation/automation/two-forms-never-a-third.md
---

# A path has two forms, never a third: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands, then the band below.
Glyphs: 3 named sets (mauve), 1 code unit (slate), 1 ADR-only; 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-path--two-forms-never-a-third--meta.drawio.png) draws, in the vocabulary of the diagram glyphs;
what it means is in [the article](../../explanation/automation/two-forms-never-a-third.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `COMMUNICATION FORM`, `THE BOUNDARY` and `BINDING FORM`, then down to one full-width band labelled `CROSS-STAGE`. It holds
five glyphs, three named sets, one code unit and one ADR-only, joined by four flow edges, with five markers and a legend panel along the
bottom. The eye lands first on the code unit in the middle band, where all four edges meet.

## Reading path

1. Marker 1, `COMMUNICATION FORM` band: the named set Communication form.
2. Right along the upper flow edge to marker 2, `THE BOUNDARY` band: the code unit The two crossers.
3. Right along the upper flow edge to marker 3, `BINDING FORM` band: the named set Binding form.
4. Back along the two lower flow edges, from Binding form through The two crossers to Communication form.
5. Marker 4, `THE BOUNDARY` band, below the code unit: the ADR-only glyph A hybrid form, joined to nothing.
6. Down to marker 5, `CROSS-STAGE` band, centre: the named set Published artifact, joined to nothing.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------- |
| named set             | 3     | Communication form (`COMMUNICATION FORM`), Binding form (`BINDING FORM`), Published artifact (`CROSS-STAGE`, centre) |
| code unit             | 1     | The two crossers (`THE BOUNDARY`, top)                                                                               |
| ADR-only              | 1     | A hybrid form (`THE BOUNDARY`, below the code unit), dashed outline on the page colour                               |

Named sets are mauve and the code unit is slate, both with light names; the ADR-only glyph is a dashed box.

## Edges

| Edge kind | Count | From → to                                                                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | Communication form → The two crossers, The two crossers → Binding form, Binding form → The two crossers, The two crossers → Communication form |

Every edge is straight and horizontal: the two rightward edges run along the upper half of the glyphs and the two leftward edges along the
lower half, so none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| slate rounded box | code unit                  |
| dashed box        | ADR-only                   |
| thin arrow        | flow: crosses the boundary |
| light disc `1`    | marker: a Walkthrough step |
| grey band         | band: one stage            |

## Sidebar

The lens badge reads `META`. The three minimaps, world map, tree and value-chain map, sit above it, and the map key below it names the four
swatches: lit, lit by passing mentions only, lit ADR file, and idle.
