# pwsh/Base.QualityGates/private/Invoke-FormatterEngine.ps1

Runs one formatter engine over the given files and returns the files it changed. It is the one place an engine name from languages.yml
becomes code: each declared engine has exactly one adapter.

## help

### synopsis

Runs one formatter engine over the given files and returns the files it changed.

### description

The one place an engine name from languages.yml becomes code: each engine LanguagesConfig.FormatterEngines declares has exactly one adapter
here, and every adapter takes the same -File and -DryRun and returns the changed files
([PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfigchange)). A
language is never named here — which language uses which engine is configuration.

### parameter `Engine`

The engine name, as languages.yml spells it.

### parameter `File`

Absolute paths of the files to format.

### parameter `DryRun`

List the files the engine would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).
