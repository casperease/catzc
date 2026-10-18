# automation/Catzc.Base.QualityGates/private/Get-GeneratorFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The generator meta kind's fact: the path of the file that writes the files the kind selects.

### description

The path is the kind's `generator` setting, data in the registry and never a list in this function
([ADR-PRIN-CONFIG#1](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config1)). The file must exist, so a head never names
a writer that has moved or gone ([ADR-REPO-FILEMETA#7](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta7)).

### parameter State

What Get-MarkdownMetaState read from the file.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
