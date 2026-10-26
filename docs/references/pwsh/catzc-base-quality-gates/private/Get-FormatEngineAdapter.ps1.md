# pwsh/Base.QualityGates/private/Get-FormatEngineAdapter.ps1

The one map from a formatter engine of `languages.yml` to the function that runs it. The engine runner calls the adapter it names, and the
cache stamp hashes the adapter's code, so a changed adapter re-checks every file it judged.

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
