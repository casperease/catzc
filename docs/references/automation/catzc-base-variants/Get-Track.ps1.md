# automation/Catzc.Base.Variants/Get-Track.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repository's tracks — all of them, the named ones, or the track that owns a path.

### description

The `tracks` repo-wide variant (configs/variants.yml, [ADR-DSGN-TRACK](../../../adr/design/tracks.md)) declares each
track: its places, its type ([ADR-DSGN-TRACKTYPE#1](../../../adr/design/track-types.md#rule-adr-dsgn-tracktype1)),
its vendor when it has one and the file languages of its tech-stack
([ADR-DSGN-TRACK#6](../../../adr/design/tracks.md#rule-adr-dsgn-track6)). Each result is a VariantTrack, in declared
order; the shape is validated by the VariantsConfig type.

-Path answers "which track does this file belong to?"
([ADR-DSGN-TRACK#1](../../../adr/design/tracks.md#rule-adr-dsgn-track1)): the track with the longest place that
contains the path ([ADR-DSGN-TRACKTYPE#5](../../../adr/design/track-types.md#rule-adr-dsgn-tracktype5)), so a narrower
place wins over a wider one (a bare place, e.g. 'docs', is its own track's path). A file at the repository root, a
path under out/ (gitignored output, never a track), and a path no place contains return nothing.

### parameter Name

The track name(s) to return. An unknown name throws, naming the config file.

### parameter Path

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
(Get-Track -Path 'docs/adr/design/tracks.md').name        # -> docs
```
