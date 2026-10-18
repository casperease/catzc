# automation/Catzc.Base.QualityGates/private/Get-FilePathFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file-path meta kind's fact: the file's repository-relative path.

### description

The path is a derived fact, so a moved file drifts and the formatter rewrites it; the H1 is the file's title, never its path
([ADR-REPO-FORMAT#6](../../../../adr/repository/uniform-formatting.md#rule-adr-repo-format6)).

It rests on [ADR-REPO-FILEMETA#3](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta3).

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
