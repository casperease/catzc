---
catzc:
  immutable:
    with_body_sha: e0c31651f0ea
    repo_status: locked
    path: docs/references/automation/catzc-tooling-python/private/Install-PipTool.ps1.md
    folder: docs/references/automation/catzc-tooling-python/private
    name: install-pip-tool-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-UVPY#2
---

# automation/Catzc.Tooling.Python/private/Install-PipTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs a Python-library tool into the uv-managed Python via `uv pip`.

### description

Private helper for Install-PySpark. Mirrors Install-Tool's contract but installs the package INTO the uv-managed Python with
`uv pip install --system` (so it stays importable, unlike an isolated `uv tool`). Handles idempotency, -Force, and version verification. uv
presence is asserted by Invoke-Pip.

### parameter Tool

The snake_case tool key as defined in tools.yml (must declare pip_package).

### parameter Version

Version override. Defaults to the tool's locked version in tools.yml (Get-ToolConfig).

### parameter Force

Uninstall a wrong version before installing the correct one.

## comment:1

Above `$pythonVersion = (Get-ToolConfig -Tool 'python').version`, written with `#`.

```text
Land the package in the toolchain's importable Python — uv's managed CPython — which needs three flags
together ([ADR-AUTO-UVPY#2](/docs/adr/automation/uv-python-handler.md#rule-adr-auto-uvpy2), "installs INTO the
uv-managed Python so import works"):
  --python <pin>          pin WHICH interpreter, so it can never drift to a stray system Python
  --system                permit a non-virtual install (uv otherwise wants a venv)
  --break-system-packages override uv's PEP-668 EXTERNALLY-MANAGED marker on its own managed CPython
                          ("This Python installation is managed by uv and should not be modified")
This is the sanctioned way to make a library (PySpark) importable by the bare `python` the version probe
runs, rather than trapping it in an isolated venv or `uv tool` env.
```

## comment:2

Above `Invoke-Pip "install --python $pythonVersion --system --break-system-packages...`, written with `#`.

```text
Install into the uv-managed Python (pinned interpreter, `--system` for its non-virtual site-packages) so
the package is importable in the interpreter the toolchain provisions, not trapped in an isolated tool env.
```

## comment:3

Above `$actualVersion = Get-ToolVersion -Config $config`, written with `#`.

```text
A pip-installed library may expose no PATH executable (PySpark's launcher lives inside the package), so
confirm it through the version probe (an import/metadata read against the managed Python) rather than
asserting a command on PATH.
```
