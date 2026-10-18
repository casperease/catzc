# automation/Catzc.Base.QualityGates/private/Get-RepoStatusFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The repo-status meta kind's fact: whether the file is locked (generated, edit its source) or clean (authored).

### description

The stored status is the part of a file's repository status that the file itself decides: `locked` for a file of a class the kind's
`locked_classes` setting lists, a generated file whose source is the truth, and `clean` for every other file. The states that only git knows
(edited, staged, committed, pushed) are never written into the file, since the write would change them.

### parameter State

What Get-MarkdownMetaState read from the file.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
