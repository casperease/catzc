# automation/Catzc.Base.QualityGates/private/Invoke-BicepFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The bicep formatter engine: formats the given Bicep files with the managed Bicep CLI and returns the files it changed.

### description

One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config2)). The Bicep
CLI is the one at the tools.yml pin (Install-Bicep), never whichever bicep is first on PATH; a missing or off-pin CLI throws, naming
Install-Bicep.

The CLI starts slowly, so it runs once for all the files: each is copied into a temporary folder, `bicep format --pattern` formats the
copies in one process, and each copy is compared byte for byte with its file, so -DryRun never touches the file; without -DryRun a changed
copy replaces it. The copies sit outside the repository, so the formatter sees no bicepconfig.json there; the repository has none, and one
that sets formatting options would be listed in the engine's `settings:` in languages.yml and passed here first.

### parameter File

Absolute paths of the .bicep files to format.

### parameter DryRun

List the files the Bicep CLI would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).
