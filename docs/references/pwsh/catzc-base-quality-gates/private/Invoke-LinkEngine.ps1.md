# pwsh/Catzc.Base.QualityGates/private/Invoke-LinkEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the link engine for a repository and runs it over a file scope.

### description

The one place Format-Links and Test-Links assemble the engine, so the aligner and the gate can never disagree: the ADR citation map
(Get-DrsCitationMap), the line limits (Get-LinkLineLimit over .editorconfig and links.yml), the default limit, the wrap mode, this
repository's web URL (Get-RepositoryWebUrl), the string-citation check's exempt globs (links.yml string_citations), and the paths git
tracks, so a markdown link to a file GitHub does not have is reported. Any other root (a test's scratch root) has no tracked set to compare
against, so the tracked check is skipped there. Reads only — the result carries each changed file's new text for the caller to write.

### parameter `RepositoryRoot`

The repository root.

### parameter `Path`

Optional files or folders to limit the run to (Get-LinkScope); default the git-tracked repository.

### parameter `Kind`

Which link kinds to process.

### parameter `Wrap`

How an aligned comment line that outgrows its limit is wrapped.

### parameter `IncludeEdge`

Also records each relation the walk recognises, as the result's `Edges`, for Test-LinkDirections. Test-Links and Format-Links leave it off,
and the result's `Edges` is then empty.

### outputs

`[Catzc.Base.QualityGates.LinkEngineResult]`
