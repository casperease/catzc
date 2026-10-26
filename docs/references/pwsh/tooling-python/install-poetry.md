# pwsh/Tooling.Python/Install-Poetry.ps1

The installer of Poetry as an isolated uv tool, in its own environment, so it never touches the uv-managed Python.

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
