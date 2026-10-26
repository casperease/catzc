# pwsh/Base.Variants/types/VariantMember.cs

One member of a track: a folder or a file, with its two facts, whether it is generated and whether it is committed
([DDR-TRACK-ISPLACEDCLUSTER](../../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster)).

## Containment

`Contains` answers whether the member holds a `/`-separated repository-relative path: a plain member holds itself and everything under it,
and a glob member holds the paths it matches.
