# pwsh/Tooling.Core/Uninstall-UvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls a uv-managed tool.

### description

Removes a CLI installed via Install-UvTool (`uv tool uninstall <uv_tool>`). Idempotent — skips if the tool is not installed.

### parameter `Tool`

The snake_case tool key as defined in tools.yml (must declare uv_tool).
