# pwsh/Tooling.Node/Install-Markdownlint.ps1

The installer of markdownlint-cli2, the linter behind `Test-Markdownlint`: a global npm package at the version `tools.yml` locks.

## help

### synopsis

Installs markdownlint-cli2 (the Markdown linter CLI) globally via npm.

### description

markdownlint-cli2 is the linter behind Test-Markdownlint. It is installed globally with npm at the version locked in tools.yml. Requires
Node.js (npm). Idempotent — skips if already installed at the locked version; -Force replaces a wrong version.

### parameter `Version`

markdownlint-cli2 version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Markdownlint
```

### example 2

```powershell
Install-Markdownlint -Force
```
