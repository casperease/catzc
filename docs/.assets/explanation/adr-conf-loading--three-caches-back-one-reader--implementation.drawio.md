# docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.drawio.md

`Three caches back one reader: the diagram described`

```text
A 1572 x 700 diagram, read left to right along one band, then down into three bands below it.
Glyphs: 4 code units (slate), 3 stores (slate), 2 files (olive), 1 result; 10 flow edges; 10 markers.
Sidebar: axis minimap (main cell AUTO x CONFIG), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-conf-loading--three-caches-back-one-reader--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/configuration/three-caches-back-one-reader.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled CALL CHAIN, then down into two bands side by side, INDEX on the left and MISS on the right, and a band labelled
REGISTRY on the bottom right that feeds MISS from below. It holds ten glyphs (four code units, three stores, two files and one result)
joined by ten edges, with ten markers and a legend panel along the bottom. The eye lands first on the wide slate cylinder in the middle of
the CALL CHAIN band.

## Reading path

1. Markers 1 and 2, CALL CHAIN band: the code units Get-Config and Resolve-ConfigEntry, left to right.
2. Down from Resolve-ConfigEntry to marker 3, INDEX band: the store $script:configIndex.
3. Marker 4, back in CALL CHAIN: the wide store $script:configCache, then right to marker 5: the result same reference.
4. Down from the store to marker 6, MISS band: the file configs/&lt;name&gt;.yml, then right to marker 7: the code unit [type]::new($raw),
   whose edge rises back into the store.
5. Markers 8, 9 and 10, REGISTRY band, left to right: the file configs.yml, the code unit Get-ConfigRegistry and the store
   $script:configRegistryCache. An edge rises from Get-ConfigRegistry into [type]::new($raw).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                 |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------- |
| code unit             | 4     | Get-Config, Resolve-ConfigEntry (CALL CHAIN); [type]::new($raw) (MISS); Get-ConfigRegistry (REGISTRY) |
| store                 | 3     | $script:configIndex (INDEX), $script:configCache (CALL CHAIN), $script:configRegistryCache (REGISTRY) |
| file                  | 2     | configs/&lt;name&gt;.yml (MISS), configs.yml (REGISTRY)                                               |
| result                | 1     | same reference (CALL CHAIN, right)                                                                    |

Code units and stores are slate and files are olive, all with white names; the result is light green.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 10    | Get-Config → Resolve-ConfigEntry, Resolve-ConfigEntry → $script:configIndex, Resolve-ConfigEntry → $script:configCache, $script:configCache → same reference, $script:configCache → configs/&lt;name&gt;.yml, configs/&lt;name&gt;.yml → [type]::new($raw), [type]::new($raw) → $script:configCache, configs.yml → Get-ConfigRegistry, Get-ConfigRegistry → $script:configRegistryCache, Get-ConfigRegistry → [type]::new($raw) |

Every edge is straight; six are horizontal and four vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                                  |
| ------------------------- | --------------------------------------- |
| slate rounded box         | code unit                               |
| slate cylinder            | store                                   |
| olive page, folded corner | file                                    |
| light green rounded box   | result                                  |
| thin arrow                | flow: call order (hit right, miss down) |
| dark disc `1`             | marker: a Walkthrough step              |

## Sidebar

- **Axis minimap:** the main cell is AUTO × CONFIG, framed and filled in the CONFIG orange with the you-are-here dot. No other cell carries
  a dot. The AUTO and CONFIG axis labels carry an orange tick.
- **Tree minimap:** two lit tiles near the bottom right, labelled Config and adr/conf.
- **Lens badge:** IMPL, with "Supports ADR-CONF-LOADING" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
