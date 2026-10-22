# pwsh/Catzc.Tooling.Listen/private/Read-ListenIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads a session's file index (seen.json or baseline.json) as path to { length, ticks, hash }.

### description

The index file must exist; an index of no files reads as an empty hashtable.

### parameter `Path`

The index file.

### outputs

`[hashtable]` path to { length, ticks, hash }.
