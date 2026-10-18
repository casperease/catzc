# pwsh/Catzc.Tooling.Core/Install-UvVenvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs a CLI into a dedicated uv venv.

### description

For a CLI whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which an isolated `uv tool` shim in ~/.local/bin breaks
by placing the launcher next to uv's --default python instead. This creates a dedicated venv (`uv venv`), installs the package into it
(`uv pip install --python <venv>`), and puts the venv's script directory on PATH — so the launcher sits beside the venv's own python and
works. Pre-release resolution (for packages that pin a beta dependency) is threaded through Invoke-Uv's -Prerelease switch, which warns.
Handles idempotency and -Force.

### parameter `Tool`

The snake_case tool key (must declare uv_venv).

### parameter `Version`

Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).

### parameter `Force`

Rebuild the venv from scratch even when the tool is already present.

## comment:1

Above ``Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear --seed"``, written with `#`.

```text
--clear rebuilds the venv clean; --seed adds pip/setuptools/wheel so packages that expect `pkg_resources`
(azure-cli's azure-devops extension) can load.
```

## comment:2

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`, written with `#`.

```text
APPEND the venv's script directory to PATH (the janitor keeps it there each load via session_path_hints).
Append, not prepend: the venv's Scripts dir also holds its own python.exe, and prepending would shadow the
uv-managed `python` on ~/.local/bin. The tool's command resolves from here because nothing earlier provides
it, while `python` stays the managed interpreter.
```
