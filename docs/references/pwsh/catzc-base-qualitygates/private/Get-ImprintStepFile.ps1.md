# pwsh/Catzc.Base.QualityGates/private/Get-ImprintStepFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the files one imprint step may write, in its own scope.

### description

A step is never named by a language: which languages it covers is configuration, so this only answers which files the step reads.

It rests on [ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../adr/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters).

### parameter `Step`

The step name, as languages.yml spells it.

### parameter `RepositoryRoot`

The repository root.

### parameter `Path`

Optional files or folders to limit the scope to.

### outputs

`[string[]]` Absolute paths.
