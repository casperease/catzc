# automation/Catzc.Tooling.Toolchain/Install-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs the Azure CLI, user-space into a dedicated uv venv.

### description

Installs az into its own uv venv (`uv venv` + `uv pip install azure-cli`) on every platform — user-space, no admin. az's launcher runs the
python beside it, so it needs a venv with its own interpreter rather than a uv-tool shim. Requires uv. Idempotent — skips if the correct
version is already on PATH.

### parameter `Version`

Azure CLI version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an existing installation at the wrong version.

### example 1

```powershell
Install-AzCli
```

### example 2

```powershell
Install-AzCli -Version '2.74'
```
