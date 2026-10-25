# pwsh/Catzc.Base.Maps/types/MapsLabels.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
The map labels (the `labels` section of configs/maps.yml): the fixed text the maps print beside the data.

The world map's labels: the title of each view, the header of each axis, the headers of the two catch-all lines of the
grid and the legend's entries. The catch-all row holds the root files
([DDR-TRACK-ROOTFILE](/docs/drs/design/tracks.md#rule-ddr-track-rootfile)) and the catch-all column the unlisted files
([DDR-TRACK-UNLISTEDFILE](/docs/drs/design/tracks.md#rule-ddr-track-unlistedfile)), so their headers print those terms.

The value-chain map's labels, each key starting value_chain_: its title, the header of each axis (the value-chain
stack and the value-chain concerns) and the legend's entries
([DDR-TRACK-VALUECHAINMAP](/docs/drs/design/tracks.md#rule-ddr-track-valuechainmap)). Test-WorldMap checks the world map's
labels and Test-ValueChainMap the value-chain map's.

The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The defaults are declared
here, once ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). MapsConfig
validates the section (every label one non-empty line of WinAnsi text, each world-map row or column header within
its limit) and builds one.
```
