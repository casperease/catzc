# pwsh/Base.QualityGates/private/Get-RelativeEdgeCandidate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists, per relation of a relative-edges kind, the paths each file's related file may have, in rule order.

### description

Expands each relation's path templates for the file (`{name}`, `{stem}`, `{module}`, `{page}`), keeping only the rules whose classes select
the file's class. It never touches the disk: Get-RelativeEdgesFileMetaFact takes the first candidate on disk as the relation's file, and
Get-FileMetaInputStamp stamps whether each one is on disk, so both read the same list.

### parameter `Path`

The repository-relative files. The relations are checked once for all of them, so a whole-tree caller passes every file in one call.

### parameter `Kind`

The meta kind whose `settings.relations` declare the relations.

### outputs

`[pscustomobject]` one per file and relation, in the given and declared order: { Path = the file; Relation = the relation's settings entry;
Paths = `string[]` in rule order }.
