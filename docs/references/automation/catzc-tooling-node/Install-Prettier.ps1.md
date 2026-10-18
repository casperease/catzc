# automation/Catzc.Tooling.Node/Install-Prettier.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs Prettier (the prettier formatter engine's CLI) globally via npm.

### description

Prettier is the engine Format-Code runs for every file language languages.yml gives `formatter: prettier`
(Markdown, pipeline YAML). It is installed globally with npm at the version locked in tools.yml. Requires
Node.js (npm). Idempotent — skips if already installed at the locked version; -Force replaces a wrong version.

### parameter Version

Prettier version to install. Defaults to the locked version in Get-ToolConfig.

### parameter Force

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Prettier
```

### example 2

```powershell
Install-Prettier -Force
```
