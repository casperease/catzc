# automation/Catzc.Base.QualityGates/private/Get-FileRoleFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file-role meta kind's fact: the role of the file, and its subkind when it has one, from the file-kinds registry.

### description

The role is the name of the kind Get-FileKind names for the path: the first kind of the registry whose globs match wins, and a file no kind
matches is `other`. The meta kind's first key holds the role and its second, when the registry entry lists one, the subkind, which is left
out of the head for a file with none. The kinds are data in the file-kinds registry, never a list in this function
([ADR-PRIN-CONFIG#1](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config1)).

It rests on [ADR-REPO-FILEMETA#3](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta3).

### parameter State

What Get-MarkdownMetaState read from the file.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
