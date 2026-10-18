# automation/Catzc.Tooling.Core/Uninstall-UvVenvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls a CLI installed into a dedicated uv venv.

### description

Removes the tool's dedicated venv (see Install-UvVenvTool). Idempotent — skips if the venv is absent.

### parameter Tool

The snake_case tool key (must declare uv_venv).
