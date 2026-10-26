# pwsh/Base.Variants/types/TrackTypeEntry.cs

One entry of the track-types registry: a track type and what it gives the tracks of that type.

## Git attributes

`gitAttributes` lists the attributes every file under a place of a track of this type gets in the generated `.gitattributes`, each with its
reason. It is empty when the type gives none.
