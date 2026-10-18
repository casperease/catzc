# pwsh/Catzc.Base.QualityGates/private/Get-LinksFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The links meta kind's fact: every link the file points at, in one spelling, sorted and without duplicates.

### description

A link into the file itself, to an anchor in it, or to its own comment page stays internal and is not listed.

It rests on [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts).

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
