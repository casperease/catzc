# automation/Catzc.Base.QualityGates/private/Get-BodyShaFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The body-sha meta kind's fact: the hash of the file's body below its front matter.

### description

The hash changes exactly when the body does; front matter and line endings never move it.

It rests on [ADR-REPO-FILEMETA#3](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta3).

### parameter State

What Get-MarkdownMetaState read from the file.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
