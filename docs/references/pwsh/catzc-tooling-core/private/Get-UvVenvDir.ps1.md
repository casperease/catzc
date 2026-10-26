# pwsh/Tooling.Core/private/Get-UvVenvDir.ps1

The private resolver of the venv directory of a `uv_venv` tool, one subdirectory per tool under a single user-space root.

## help

### synopsis

Returns the dedicated uv-venv directory for a tool installed via `uv_venv`.

### description

A `uv_venv` tool (e.g. the Azure CLI) lives in its own venv so the package's launcher finds an adjacent python. All such venvs sit under one
user-space root — %LOCALAPPDATA%\catzc\venvs on Windows, ~/.local/share/catzc/venvs on Unix — one subdirectory per tool. The venv's script
directory (Scripts on Windows, bin on Unix) is what goes on PATH.

### parameter `Tool`

The snake_case tool key.
