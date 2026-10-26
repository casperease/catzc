# pwsh/Tooling.Core/Install-UvTool.ps1

The installer of a Python-based CLI as an isolated uv tool, the counterpart of `Install-Tool` for the uv family.

## help

### synopsis

Installs a CLI as an isolated uv tool.

### description

Mirrors Install-Tool's contract but installs via `uv tool install <uv_tool>==<version>.*` — each tool gets its own isolated environment with
uv's managed Python (user-space, no admin, no shared-env pollution). Used for az_cli, poetry, and other Python-based CLIs. Handles
idempotency, -Force, and version verify. uv is the install mechanism, so it must be present (Invoke-Uv asserts it).

### parameter `Tool`

The snake_case tool key as defined in tools.yml (must declare uv_tool).

### parameter `Version`

Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).

### parameter `Force`

Uninstall a wrong version before installing the correct one.

## Resolution

uv resolves the package's own compatible Python and installs it in an isolated environment. Pre-release resolution, for packages that pin a
beta dependency, is threaded through `Invoke-Uv`'s `-Prerelease` switch, which reports it.
