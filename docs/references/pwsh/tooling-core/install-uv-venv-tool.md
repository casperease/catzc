# pwsh/Tooling.Core/Install-UvVenvTool.ps1

The installer of a CLI into a venv of its own, for a launcher that expects `python.exe` beside it.

## help

### synopsis

Installs a CLI into a dedicated uv venv.

### description

For a CLI whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which an isolated `uv tool` shim in ~/.local/bin breaks
by placing the launcher next to uv's --default python instead. This creates a dedicated venv (`uv venv`), installs the package into it
(`uv pip install --python <venv>`), and puts the venv's script directory on PATH — so the launcher sits beside the venv's own python and
works. Pre-release resolution (for packages that pin a beta dependency) is threaded through Invoke-Uv's -Prerelease switch, which warns.
Handles idempotency and -Force.

### parameter `Tool`

The snake_case tool key (must declare uv_venv).

### parameter `Version`

Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).

### parameter `Force`

Rebuild the venv from scratch even when the tool is already present.

## The venv

`--clear` rebuilds the venv clean, and `--seed` adds pip, setuptools and wheel so packages that expect `pkg_resources`, such as azure-cli's
azure-devops extension, can load.

## PATH

The venv's script directory is appended to PATH, and `session_path_hints` keeps it there on each load. It is appended, not prepended,
because the directory also holds its own `python.exe`, and prepending would shadow the uv-managed `python` on `~/.local/bin`. The tool's
command still resolves from there because nothing earlier provides it.
