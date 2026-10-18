# automation/Catzc.Tooling.Node/Install-Markdownlint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
