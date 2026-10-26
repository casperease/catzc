# pwsh/Base.QualityGates/private/Get-FormatEngineVersion.ps1

Returns the version the installed tool of a formatter engine reports, for the engine's cache stamp. Reading the installed tool, not its pin,
means an upgrade the pin never saw still re-checks every file.

## help

### synopsis

Returns the version the installed tool of a formatter engine reports, for the engine's cache stamp.

### description

Probes the engine's tool through Resolve-ToolExecutable, so an upgrade the tools.yml pin never saw still re-checks every file the engine
judged. Returns `missing` when the tool is not found, and an empty string for an engine whose stamp already reads its pin (ruff from
python.yml, PSScriptAnalyzer from its vendored folder).

### parameter `Engine`

The formatter engine, one of the engines languages.yml declares.

### outputs

`[string]` The reported version, `missing`, or an empty string.
