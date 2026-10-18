# automation/Catzc.Base.QualityGates/private/Get-FileTypeFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file-type meta kind's fact: the file type of the file, the extension of its name.

### description

The file type is the one Get-PathFileType names for the path ([ADR-DSGN-TRACK#6](../../../../adr/design/tracks.md#rule-adr-dsgn-track6));
the kind's `keys` name the head key it is written under. A file with no extension gets an empty value, so the key is left out of its head.

### parameter State

What Get-MarkdownMetaState read from the file.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
