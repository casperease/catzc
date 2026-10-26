# pwsh/Tooling.Python/private/Install-PipTool.ps1

The private installer behind every Python-library tool: it puts a package into the uv-managed Python, pinned to the locked interpreter, and
verifies the result through the version probe.

## help

### synopsis

Installs a Python-library tool into the uv-managed Python via `uv pip`.

### description

Private helper for Install-PySpark. Mirrors Install-Tool's contract but installs the package INTO the uv-managed Python with
`uv pip install --system` (so it stays importable, unlike an isolated `uv tool`). Handles idempotency, -Force, and version verification. uv
presence is asserted by Invoke-Pip.

### parameter `Tool`

The snake_case tool key as defined in tools.yml (must declare pip_package).

### parameter `Version`

Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).

### parameter `Force`

Uninstall a wrong version before installing the correct one.

## Into the managed Python

The package lands in the toolchain's importable Python, uv's managed CPython, which takes three flags together
([ADR-AUTO-UVPY-TWOINSTALLSHAPES](../../../../drs/automation/uv-python-handler.md#rule-adr-auto-uvpy-twoinstallshapes)):

- `--python <pin>` pins which interpreter, so the install never drifts to a stray system Python;
- `--system` permits a non-virtual install, which uv otherwise refuses without a venv;
- `--break-system-packages` overrides the PEP 668 marker on uv's own managed CPython ("This Python installation is managed by uv and should
  not be modified").

This is the sanctioned way to make a library importable by the bare `python` the version probe runs, rather than trapping it in an isolated
venv or `uv tool` environment.

## Verifying the install

A pip-installed library may put no executable on PATH; PySpark's launcher lives inside the package. The install is therefore confirmed
through the version probe, an import or metadata read against the managed Python, and never by asserting that a command exists.
