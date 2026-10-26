# pwsh/Base.Variants/Get-Track.ps1

The track lookup: every track the variants config declares, the named ones, or the one track that owns a path, by the longest place that
contains it.

## help

### synopsis

Returns the repository's tracks — all of them, the named ones, or the track that owns a path.

### description

The `tracks` repo-wide variant (configs/variants.yml, [DDR-TRACK](../../../drs/design/tracks.md)) declares each track: its places, its type
([DDR-TRACKTYPE-CLOSEDSETOFTYPES](../../../drs/design/track-types.md#rule-ddr-tracktype-closedsetoftypes)), its vendor when it has one and
the file languages of its tech-stack ([DDR-TRACK-FILELANGUAGE](../../../drs/design/tracks.md#rule-ddr-track-filelanguage)). Each result is a
VariantTrack, in declared order; the shape is validated by the VariantsConfig type.

-Path answers "which track does this file belong to?"
([DDR-TRACK-TRACKISPLACEDCLUSTER](../../../drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)): the track with the longest place that
contains the path ([DDR-TRACKTYPE-LONGESTPLACEWINS](../../../drs/design/track-types.md#rule-ddr-tracktype-longestplacewins)), so a narrower
place wins over a wider one (a bare place, e.g. 'docs', is its own track's path). A file at the repository root, a path under out/
(gitignored output, never a track), and a path no place contains return nothing.

### parameter `Name`

The track name(s) to return. An unknown name throws, naming the config file.

### parameter `Path`

A repository-relative path ('/' or '\' separated); returns the track that owns it.

### example 1

```powershell
Get-Track
```

### example 2

```powershell
(Get-Track -Name automation).type                        # -> modules
```

### example 3

```powershell
(Get-Track -Path 'docs/drs/design/tracks.md').name        # -> docs
```
