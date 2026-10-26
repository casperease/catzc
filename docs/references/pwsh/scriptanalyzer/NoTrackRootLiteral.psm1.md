# pwsh/.scriptanalyzer/NoTrackRootLiteral.psm1

The custom analyzer check `Measure-NoTrackRootLiteral`: no string spells a place of the modules track.

## The places

The modules track's places and the exempt globs are read once per analyzer session ([ADR-AUTO-LAYERS](../../../drs/automation/layers.md)).
The relocatable modules root (`Get-CatzcModulesRoot`) holds the track whose modules run under this engine, pwsh; its places are the ones no
string may spell.

## Bare place names

A bare place name is also a word with other senses (an ADR domain, a layer), so alone it counts only where a path is built.

## Locating the track

Module folders resolve from their full names under the track's namespace, read before any import
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
