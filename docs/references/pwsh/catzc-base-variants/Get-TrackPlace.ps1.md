# pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the place pattern of one kind of a track, as the variants config declares it.

### description

A track names its kinds under `kinds:` in the `tracks` repo-wide variant (configs/variants.yml, [DDR-TRACK](../../../drs/design/tracks.md));
each kind maps to a place pattern, a wildcard segment kept as written. A kind the track does not name throws, listing the kinds it does name
and the config to declare it in; an unknown track throws as Get-Track does.

### parameter `Track`

The track name.

### parameter `TrackKind`

The kind of the track to place, e.g. `templates`.

### outputs

`[string]` The place pattern of the kind.

### example 1

```powershell
Get-TrackPlace -Track infrastructure -TrackKind templates       # -> infrastructure/templates
```
