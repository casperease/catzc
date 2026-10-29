# pwsh/Base.Slides/private/Assert-DiagramKitSynced.ps1

Guards the draw.io kit's Python environment: the diagram commands run `uv run --no-sync`, so they fail at once when `python/.venv` was never
synced, rather than sync it themselves.

## help

### synopsis

Throws when the diagram kit's Python environment is not synced.

### description

The kit runs as `uv run --no-sync`, so the environment must come from the explicit install command. When `<python root>/.venv/pyvenv.cfg` is
missing the function throws and names the one command that syncs it, `Install-PythonWorkspace`. The diagram commands never sync the
environment themselves. Build-Diagrams, Test-Diagrams and Move-Diagram call this before their `uv run --no-sync` calls.

### outputs

`[void]`. Throws when the environment is not synced.
