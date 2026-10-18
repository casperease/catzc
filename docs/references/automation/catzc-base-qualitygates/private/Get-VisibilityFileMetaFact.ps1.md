# automation/Catzc.Base.QualityGates/private/Get-VisibilityFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The visibility meta kind's fact: whether a module's function file is public or private, from its folder.

### description

A file in the module's private folder is private, and any other file of the module is public. The modules root and the folder name are the
kind's `root` and `private_folder` settings, `automation` and `private` unless the registry says otherwise.

It rests on [ADR-REPO-CODEMETA#2](../../../../adr/repository/code-file-meta.md#rule-adr-repo-codemeta2).

### parameter State

What the file's carrier reader returned.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
