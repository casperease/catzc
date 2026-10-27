# pwsh/Tooling.Python/Install-PythonWorkspace.ps1

The one online sync of the Python test workspace: the explicit tooling command that makes the environment `Invoke-PythonTest`,
`Test-PythonLint` and `Test-PythonTypes` read offline
([ADR-AUTO-NET-NODEFAULTPATH](../../../drs/automation/network-calls.md#rule-adr-auto-net-nodefaultpath)).

## help

### synopsis

Syncs the Python test workspace's one environment through uv, online, so test runs and the Python checks read it offline.

### description

Runs `uv sync --all-packages` from the Python root (python.yml's root) with the managed uv at the tools.yml pin, then makes pyright's first
run, which fetches what its wrapper lacks. uv runs with UV_PYTHON_DOWNLOADS=never, so a missing interpreter fails with the remedy
Install-Python. A test run and the Python checks never sync; they throw naming this command when the environment is missing.

### parameter `ReinstallPackage`

Workspace packages to reinstall, such as a strict editable kit with a new module that has no link yet.

### example 1

```powershell
Install-PythonWorkspace
```

### example 2

```powershell
Install-PythonWorkspace -ReinstallPackage widget-sprockets
```
