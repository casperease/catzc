# pwsh/Catzc.Base.QualityGates/private/Get-AdrDefinesFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The adr-defines meta kind's fact: the rules an ADR defines itself, spelled as citations.

### description

The rules come from the file's own rule headings, so the list is what the file declares and not what it cites. Each is its rule code, in the
order the headings stand, with no group or glob.

It rests on [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts).

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
