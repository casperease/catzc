# pwsh/Catzc.Base.QualityGates/private/Get-VendorFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The vendor meta kind's fact: the vendor that reads the files of the track that holds the file.

### description

The track is the one Get-Track names for the path, and its vendor is the one the `tracks` registry declares for it
([ADR-DSGN-TRACKTYPE-OPTIONALVENDOR](../../../../adr/design/track-types.md#rule-adr-dsgn-tracktype-optionalvendor)). A root file, and a file
of a track with no vendor, gets an empty value, so the key is left out of its head.

It rests on [ADR-DSGN-TRACKTYPE-HEADREADSDECLARATION](../../../../adr/design/track-types.md#rule-adr-dsgn-tracktype-headreadsdeclaration).

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
