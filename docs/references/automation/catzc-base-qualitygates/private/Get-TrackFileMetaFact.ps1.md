# automation/Catzc.Base.QualityGates/private/Get-TrackFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The track meta kind's fact: the track whose root folder holds the file.

### description

The track is the one Get-Track names for the path, from the `tracks` registry
([ADR-DSGN-TRACK#1](../../../../adr/design/tracks.md#rule-adr-dsgn-track1)). A root file, which no track holds, gets an empty value, so
the key is left out of its head.

### parameter State

What Get-MarkdownMetaState read from the file.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
