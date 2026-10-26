# pwsh/Tooling.Node/Install-Cspell.ps1

The installer of cspell, the spell checker behind `Test-Spelling`: a global npm package at the version `tools.yml` locks.

## help

### synopsis

Installs cspell (the Code Spell Checker CLI) globally via npm.

### description

cspell is the spell-checker behind Test-Spelling. It is installed globally with npm at the version locked in tools.yml. Requires Node.js
(npm). Idempotent — skips if already installed at the locked version; -Force replaces a wrong version.

### parameter `Version`

cspell version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Cspell
```

### example 2

```powershell
Install-Cspell -Force
```
