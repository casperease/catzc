# pwsh/Catzc.Tooling.Listen/private/Write-ListenIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes a session's file index, its paths in ordinal order, so two equal indexes are equal files.

### description

The index is written as JSON, UTF-8 without a byte-order mark, replacing the file.

### parameter `Path`

The index file to write.

### parameter `Index`

Path to { length, ticks, hash }, as Get-ListenFileIndex builds it.
