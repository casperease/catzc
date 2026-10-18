# automation/Catzc.Tooling.Python/Install-Python.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Provisions Python via uv.

### description

Installs a uv-managed CPython (`uv python install <version> --default`) — user-space, cross-platform, with a global python/python3 shim in
uv's bin (~/.local/bin). Requires uv. Idempotent — skips if the correct version is already on PATH.

NOT for CI pipelines. In Azure DevOps, use the native UsePythonVersion task which activates pre-cached versions instantly:

- task: UsePythonVersion@0 inputs: versionSpec: '3.11'

### parameter Version

Python version to install. Defaults to the locked version in Get-ToolConfig.

### parameter Force

Reinstall even when a build is already present (uv --reinstall).

### example 1

```powershell
Install-Python
```

### example 2

```powershell
Install-Python -Version '3.12'
```

## comment:1

Above `$reinstall = if ($Force) {`, written with `#`.

```text
uv resolves the newest matching CPython, installs it, and (--default) writes the global python/python3
shims into its bin dir. --default is still behind uv's preview flag, so opt in explicitly with
--preview-features to keep it (and silence uv's experimental warning, which WarningPreference=Stop
would otherwise turn into a halt). --reinstall replaces an existing build of the same version under -Force.
```
