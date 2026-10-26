# pwsh/Tooling.Python/Invoke-Pip.ps1

The way to run pip: a thin delegate to `Invoke-Uv` that prefixes `pip`, so every pip call goes through uv.

## help

### synopsis

Runs pip through uv (`uv pip`).

### description

Delegates to Invoke-Uv, so `Invoke-Pip 'install --system requests'` runs `uv pip install --system requests` against the uv-managed Python.
uv is the standard Python handler; installs that target the global interpreter pass `--system` (see Install-PipTool). uv presence is
asserted by Invoke-Uv.

### parameter `Arguments`

Arguments to pass to `uv pip`.

### parameter `PassThru`

Return a CliResult object with Output, Errors, Full, and ExitCode.

### parameter `NoAssert`

Skip exit code assertion.

### parameter `Silent`

Suppress the command log line and all console output.

### parameter `DryRun`

Return the command string without executing. Used for testing.

### example 1

```powershell
Invoke-Pip 'install --system requests'
```

### example 2

```powershell
Invoke-Pip 'list --format json' -DryRun
```
