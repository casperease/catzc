# pwsh/Tooling.Python/Install-Python.ps1

The provisioner of the toolchain's Python: a uv-managed CPython at the locked version, made the default through uv's global shims.

## help

### synopsis

Provisions Python via uv.

### description

Installs a uv-managed CPython (`uv python install <version> --default`) — user-space, cross-platform, with a global python/python3 shim in
uv's bin (~/.local/bin). Requires uv. Idempotent — skips if the correct version is already on PATH.

NOT for CI pipelines. In Azure DevOps, use the native UsePythonVersion task which activates pre-cached versions instantly:

- task: UsePythonVersion@0 inputs: versionSpec: '3.11'

### parameter `Version`

Python version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Reinstall even when a build is already present (uv --reinstall).

### example 1

```powershell
Install-Python
```

### example 2

```powershell
Install-Python -Version '3.12'
```

## How uv installs it

uv resolves the newest CPython that matches the version, installs it and, with `--default`, writes the global `python` and `python3` shims
into its bin directory. `--default` still sits behind uv's preview flag, so the command opts in explicitly with `--preview-features`: the
shims stay, and uv's experimental warning never halts a run that stops on warnings. Under `-Force`, `--reinstall` replaces an existing build
of the same version.
