# pwsh/Catzc.Tooling.Python/Install-Poetry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs Poetry as an isolated uv tool.

### description

Installs Poetry user-space via uv (`uv tool install poetry`) in its own environment. Requires uv. Idempotent — skips if the correct version
is already on PATH.

### parameter `Version`

Poetry version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-Poetry
```

### example 2

```powershell
Install-Poetry -Version '2.0'
```
