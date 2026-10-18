# pwsh/Catzc.Base.QualityGates/private/Get-ModuleNameFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The module-name meta kind's fact: the name of the module a file is placed in, from the module-types registry.

### description

The module is the one Get-PathModule names for the path, by the places the module types of the module-types registry give. A file placed in
no module gets an empty value, so the key is left out of its head.

It rests on [ADR-REPO-CODEMETA#2](../../../../adr/repository/code-file-meta.md#rule-adr-repo-codemeta2).

### parameter `State`

What the file's carrier reader returned.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
