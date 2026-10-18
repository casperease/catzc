# pwsh/Catzc.Base.QualityGates/private/Invoke-FormatterEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs one formatter engine over the given files and returns the files it changed.

### description

The one place an engine name from languages.yml becomes code: each engine LanguagesConfig.FormatterEngines declares has exactly one adapter
here, and every adapter takes the same -File and -DryRun and returns the changed files
([ADR-PRIN-CONFIG#2](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config2)). A language is never named here — which
language uses which engine is configuration.

### parameter `Engine`

The engine name, as languages.yml spells it.

### parameter `File`

Absolute paths of the files to format.

### parameter `DryRun`

List the files the engine would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).
