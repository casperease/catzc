# pwsh/Tooling.Core/Uninstall-UvVenvTool.ps1

The remover of a CLI that `Install-UvVenvTool` installed into a venv of its own: it deletes that venv. It is idempotent.

## help

### synopsis

Uninstalls a CLI installed into a dedicated uv venv.

### description

Removes the tool's dedicated venv (see Install-UvVenvTool). Idempotent — skips if the venv is absent.

### parameter `Tool`

The snake_case tool key (must declare uv_venv).
