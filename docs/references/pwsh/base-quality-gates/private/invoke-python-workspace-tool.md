# pwsh/Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1

Runs a tool from the Python test workspace's pinned environment (ruff) against any `.py` files in the repository. The Python checks use one
pinned tool set for every tracked Python file, not only the test folders.

## help

### synopsis

Runs a tool from the Python test workspace's pinned environment (ruff), against any .py files in the repository.

### description

The Python checks run one pinned tool set for every .py file the repository tracks — the Python tests, and the agent helpers under .claude/
([ADR-AUTO-PY-EVERYFILELINTED](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfilelinted)). The tools are
the workspace's dependencies (python.yml), read from the environment the explicit Install-PythonWorkspace synced; this never syncs, and runs
`uv run --no-sync <tool> <arguments> --config pyproject.toml <files>` from the workspace root, the Python root: the explicit --config gives
every file the workspace's ruff settings (the 140-column line, the pinned Python), wherever it lives.

uv is the managed uv (Resolve-ToolExecutable, the tools.yml `uv` entry), run with UV_OFFLINE=1 and UV_PYTHON_DOWNLOADS=never so it never
reaches an index or fetches an interpreter. pyright's wrapper is held to its bundled copy at the python.yml pin
(PYRIGHT_PYTHON_FORCE_VERSION, PYRIGHT_PYTHON_USE_BUNDLED_PYRIGHT), with no version check against the index (PYRIGHT_PYTHON_IGNORE_WARNINGS)
and npm offline (npm_config_offline). Every variable is restored afterwards. Throws with "Run Install-Uv" when no uv at the pin is found,
and naming Install-PythonWorkspace when the workspace environment is missing.

### parameter `Tool`

The tool and its subcommand words, e.g. 'ruff format --check' or 'ruff check'.

### parameter `File`

The files and folders to run it on, as full paths.

### parameter `ConfigOption`

The option that hands the tool the workspace's pyproject.toml: '--config' (the default, ruff) or '--project' (pyright).

### outputs

`[Catzc.Base.Execution.CliResult]` The tool's result; a non-zero exit is the caller's to read.

### example 1

```powershell
$check = Invoke-PythonWorkspaceTool -Tool 'ruff check' -File $files
```
