# pwsh/Catzc.Base.QualityGates/private/Get-ModuleTypeFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The module-type meta kind's fact: the type of the module a file is placed in, from the module-types registry.

### description

The module type is the one Get-PathModule names for the path
([ADR-DSGN-TRACK-ONETECHSTACK](../../../../adr/design/tracks.md#rule-adr-dsgn-track-onetechstack)): a pwsh-folder, a settings, a pipeline
and so on, as the module-types registry declares them. A file placed in no module gets an empty value, so the key is left out of its head.

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
