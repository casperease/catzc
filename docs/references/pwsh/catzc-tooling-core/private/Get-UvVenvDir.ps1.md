# pwsh/Tooling.Core/private/Get-UvVenvDir.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the dedicated uv-venv directory for a tool installed via `uv_venv`.

### description

A `uv_venv` tool (e.g. the Azure CLI) lives in its own venv so the package's launcher finds an adjacent python. All such venvs sit under one
user-space root — %LOCALAPPDATA%\catzc\venvs on Windows, ~/.local/share/catzc/venvs on Unix — one subdirectory per tool. The venv's script
directory (Scripts on Windows, bin on Unix) is what goes on PATH.

### parameter `Tool`

The snake_case tool key.
