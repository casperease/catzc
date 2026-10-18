# pwsh/Catzc.Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a tool from the Python test workspace's pinned environment (ruff), against any .py files in the repository.

### description

The Python checks run one pinned tool set for every .py file the repository tracks — the Python tests, and the agent helpers under .claude/
([ADR-AUTO-PY#8](../../../../adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)). The tools are the workspace's dependencies
(python.yml), so this syncs the workspace once (`uv sync --all-packages`) and runs
`uv run --no-sync <tool> <arguments> --config pyproject.toml <files>` from the workspace root, the Python root: the explicit --config gives
every file the workspace's ruff settings (the 140-column line, the pinned Python), wherever it lives.

uv is the managed uv (Resolve-ToolExecutable, the tools.yml `uv` entry), run with UV_PYTHON_DOWNLOADS=never so it never fetches an
interpreter; the variable is restored afterwards. Throws with "Run Install-Uv" when no uv at the pin is found, and with uv's output when the
sync fails (a missing interpreter names Install-Python).

### parameter `Tool`

The tool and its subcommand words, e.g. 'ruff format --check' or 'ruff check'.

### parameter `File`

The files and folders to run it on, as full paths.

### outputs

`[Catzc.Base.Execution.CliResult]` The tool's result; a non-zero exit is the caller's to read.

### example 1

```powershell
$check = Invoke-PythonWorkspaceTool -Tool 'ruff check' -File $files
```
