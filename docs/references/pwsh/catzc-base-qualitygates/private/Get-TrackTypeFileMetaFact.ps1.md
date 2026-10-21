# pwsh/Catzc.Base.QualityGates/private/Get-TrackTypeFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The track-type meta kind's fact: the type of the track that holds the file.

### description

The track is the one Get-Track names for the path, and its type is the track type the `tracks` registry declares for it
([ADR-DSGN-TRACKTYPE-FACTSFROMDECLARATION](../../../../adr/design/track-types.md#rule-adr-dsgn-tracktype-factsfromdeclaration)). A root
file, which no track holds, gets an empty value, so the key is left out of its head.

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
