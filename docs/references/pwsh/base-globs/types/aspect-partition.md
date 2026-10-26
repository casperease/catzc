# pwsh/Base.Globs/types/AspectPartition.cs

The static helper that turns an ordered aspect convention into scan programs, finds the aspect of a file, and checks that a partition holds
([DDR-ASPECT](../../../../drs/design/module-aspects.md)).

## Compile

`Compile` applies the ordered aspect convention onto a unit root (for example `pwsh/Base.Globs`). Each aspect's include is its own patterns,
and its exclude is every earlier aspect's patterns, all prefixed by the unit root. The last aspect, the `**` catch-all, thus becomes
everything under the root minus every earlier aspect: the remainder.

## AspectOf

`AspectOf` returns the aspect of one file: the first aspect, in the map's order, one of whose sets claims it, or null when none does. The
map is `Get-AspectGlobSet`'s: aspect name to that aspect's globsets.

## Validate

`Validate` is the partition check
([DDR-ASPECT-PARTITIONISCHECKED](../../../../drs/design/module-aspects.md#rule-ddr-aspect-partitionischecked)) over a file universe: every
file is selected by exactly one aspect. It returns human-readable violations, and an empty result is a valid partition. A file claimed by
two aspects breaks disjointness, and a file claimed by none breaks exhaustiveness.
