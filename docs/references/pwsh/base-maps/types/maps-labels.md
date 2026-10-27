# pwsh/Base.Maps/types/MapsLabels.cs

The `labels` section of `configs/maps.yml`: the fixed text the maps print beside the data. `MapsConfig` validates the section and builds
one.

## World map

The world map's labels are the title of each view, the header of each axis, the headers of the two catch-all lines of the grid and the
legend's entries. The catch-all row holds the root files ([DDR-TRACK-ROOTFILE](../../../../drs/design/tracks.md#rule-ddr-track-rootfile))
and the catch-all column the unlisted files ([DDR-TRACK-UNLISTEDFILE](../../../../drs/design/tracks.md#rule-ddr-track-unlistedfile)), so
their headers print those terms.

## Value-chain map

The value-chain map's labels each start `value_chain_`: its title, the header of each axis (the value-chain stack and the value-chain
concerns) and the legend's entries ([ADR-REPO-VALUECHAIN-MAP](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map)).
`Test-WorldMap` checks the world map's labels and `Test-ValueChainMap` the value-chain map's.

## Validation and defaults

Every label is one non-empty line of WinAnsi text, and each world-map row or column header fits its limit. The defaults are declared here,
once ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). The
properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
