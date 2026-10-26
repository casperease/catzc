# pwsh/Base.QualityGates/private/Get-FormatEngineAdapter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names the adapter function that runs a formatter engine.

### description

The one map from a languages.yml formatter engine to the function that runs it: Invoke-FormatterEngine calls the adapter it names, and
Get-FormatEngineStamp hashes that adapter's code into the engine's cache stamp, so a changed adapter re-checks every file it judged. Throws
for an engine no adapter runs.

### parameter `Engine`

The formatter engine, one of the engines languages.yml declares.

### outputs

`[string]` The adapter function's name.
