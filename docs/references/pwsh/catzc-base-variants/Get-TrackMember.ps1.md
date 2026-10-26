# pwsh/Catzc.Base.Variants/Get-TrackMember.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the members of the tracks, each with its track name and its generated and committed facts.

### description

A track is declared once as a set of members ([DDR-TRACK-TRACKISPLACEDCLUSTER](../../../drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)),
each a folder or a file that says whether it is generated and whether git tracks it. This lists them as flat records, every track's or the
named ones', so a filter, a gate or a trigger reads the facts from the one declaration instead of keeping its own list. With `-Path` it
answers the one member that contains the path, the longest, in the track `Get-Track -Path` finds, so the two never disagree. Get-Track keeps
returning the tracks; the member facts are this command's.

### parameter `Name`

The tracks to list the members of. Omitted: every track.

### parameter `Path`

A repository-relative path; returns the member that contains it, or nothing when no track holds it.

### parameter `Generated`

Keeps only the members whose `generated` fact is this value.

### parameter `Committed`

Keeps only the members whose `committed` fact is this value.

### outputs

`[Catzc.Base.Variants.TrackMember]` One per member: `track`, `path`, `generated`, `committed`.

### example 1

```powershell
Get-TrackMember -Generated $true -Committed $false     # the gitignored output each track holds
```

### example 2

```powershell
Get-TrackMember -Path importer.ps1                     # the member that holds a file, with its facts
```
