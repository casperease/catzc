# pwsh/Base.QualityGates/private/Invoke-BicepFormat.ps1

The bicep formatter engine: it formats the given Bicep files with the managed Bicep CLI and returns the files it changed. It is one
Format-Code engine adapter.

## help

### synopsis

The bicep formatter engine: formats the given Bicep files with the managed Bicep CLI and returns the files it changed.

### description

One Format-Code engine adapter
([PDR-CONFIG-NEWINSTANCEISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfig)). The Bicep CLI
is the one at the tools.yml pin (Install-Bicep), never whichever bicep is first on PATH; a missing or off-pin CLI throws, naming
Install-Bicep.

The CLI starts slowly, so it runs once for all the files: each is copied into a temporary folder, `bicep format --pattern` formats the
copies in one process, and each copy is compared byte for byte with its file, so -DryRun never touches the file; without -DryRun a changed
copy replaces it. The copies sit outside the repository, so the formatter sees no bicepconfig.json there; the repository has none, and one
that sets formatting options would be listed in the engine's `settings:` in languages.yml and passed here first.

### parameter `File`

Absolute paths of the .bicep files to format.

### parameter `DryRun`

List the files the Bicep CLI would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).

## Numbered copies

Each file is formatted as a numbered copy in a scratch folder, and the copy keeps its extension. Two files of one name in different folders
never collide, and a `.bicepparam` file formats without its `using` target.
