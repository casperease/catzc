# pwsh/Catzc.Base.QualityGates/private/Get-FileNameFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The file-name meta kind's facts: the folder of the file under its module, and its name in kebab case.

### description

The path under the module (the whole path for a file placed in no module) is split into an optional folder, a kebab-case name and the file
type, which the file-type kind writes ([ADR-REPO-FILEMETA#11](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta11)). The split
asserts that the three build the path back, so a path that is not made of them stops the run. A file directly in its module has no folder,
so that key is left out of its head.

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Kind`

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind.
