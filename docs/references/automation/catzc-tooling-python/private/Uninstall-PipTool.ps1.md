# automation/Catzc.Tooling.Python/private/Uninstall-PipTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls a Python-library tool from the uv-managed Python via `uv pip`.

### description

Private helper for Uninstall-PySpark. Mirrors Uninstall-Tool's contract but removes the package from the uv-managed Python with
`uv pip uninstall --system`. Idempotent — skips if the tool or Python is not installed.

### parameter Tool

The snake_case tool key as defined in tools.yml.
