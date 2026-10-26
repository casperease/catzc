# pwsh/Tooling.Node/Install-Prettier.ps1

The installer of Prettier, the formatter engine behind `Format-Code`: a global npm package at the version `tools.yml` locks.

## help

### synopsis

Installs Prettier (the prettier formatter engine's CLI) globally via npm.

### description

Prettier is the engine Format-Code runs for every file language languages.yml gives `formatter: prettier` (Markdown, pipeline YAML). It is
installed globally with npm at the version locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the
locked version; -Force replaces a wrong version.

### parameter `Version`

Prettier version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Prettier
```

### example 2

```powershell
Install-Prettier -Force
```
