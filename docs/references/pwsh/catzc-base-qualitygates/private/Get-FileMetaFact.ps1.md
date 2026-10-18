# pwsh/Catzc.Base.QualityGates/private/Get-FileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Collects the place facts and the edges of one file from every imprint kind that selects it, by the file's class and language.

### description

Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the run and names
the function it expected. A processor must return exactly the keys its kind declares, so a kind can never write a key another kind owns.
Each key goes into the part its kind names, `immutable` or `edges`, and comes back in registry order, which is the order it is written.

It rests on [ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction).

### parameter `State`

What Get-MarkdownMetaState read from the file.

### parameter `Path`

The file's repository-relative path.

### parameter `Config`

The meta-kind registry.

### outputs

`[pscustomobject]` @{ Immutable; Edges }, each an ordered dictionary of key to value, in registry order.
