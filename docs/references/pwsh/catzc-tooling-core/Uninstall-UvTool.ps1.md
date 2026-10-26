# pwsh/Tooling.Core/Uninstall-UvTool.ps1

The remover of a CLI that `Install-UvTool` installed as an isolated uv tool. It is idempotent.

## help

### synopsis

Uninstalls a uv-managed tool.

### description

Removes a CLI installed via Install-UvTool (`uv tool uninstall <uv_tool>`). Idempotent — skips if the tool is not installed.

### parameter `Tool`

The snake_case tool key as defined in tools.yml (must declare uv_tool).
