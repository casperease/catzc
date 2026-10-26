# pwsh/Base.Languages/New-PythonProject.ps1

`New-PythonProject` renders the Python test workspace from `python.yml`: the uv workspace root `pyproject.toml` and one member
`pyproject.toml` per Python test folder and per module of the python track. `Build-RootConfig` writes the result.

## help

### synopsis

Renders the Python test workspace, the uv workspace root pyproject.toml and one member pyproject.toml per Python test folder.

### description

Python code in this repository is test artifacts only: black-box tests in `<root>/tests/<module-in-kebab>/`, under the Python root
(python.yml `root`: python/ when the repository has one, else .python/;
[ADR-AUTO-PY](../../../drs/automation/python/python-test-artifacts.md)). The tests form one uv workspace — uv's own monorepo layout, and the
Python form of go.work with one go.mod per module:

```text
<root>/pyproject.toml                  the workspace root: a virtual root (no project of its own) whose
                                       [tool.uv.workspace] members name every Python test folder explicitly, and
                                       the ruff settings for every member (the 140-column line, the pinned Python);
<root>/tests/<folder>/pyproject.toml   one member per folder holding a test_*.py file: a virtual project named for
                                       the folder, whose requires-python is the python tool's pin in tools.yml
                                       (global.tools.python.version, 3.13 -> ==3.13.*) and whose dependencies are
                                       python.yml's exact pins, in name order.
```

A module of the python track (a folder the module-type registry names, holding Python code) is a member too, at `<root>/<module>/`: a
package named for the track's namespace and its folder (`catzc.diagrams`), which the build backend PythonConfig declares maps onto the short
folder. Its manifest carries `[build-system]`, the package, its package-dir and package data, and `package = true`; the workspace root names
each package's editable mode under `[tool.uv.config-settings-package]`, the one place uv reads a build's settings.

uv makes one environment (`<root>/.venv`) and one lock (`<root>/uv.lock`) for the whole workspace when the test bridge syncs it; both are
gitignored, as these files are. A repository without Python test folders or modules renders nothing.

### parameter `LineLength`

The ruff line length, from the caller: the width the file limits declare for `.py` files, rendered as `line-length` on the workspace root.

This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config registry names for the workspace
targets, and Build-RootConfig owns the write; the entry's target selects which files.

### parameter `Target`

The files to render, as a repository-relative wildcard over their paths. Default: every file.

### outputs

`[Catzc.Base.Languages.PythonWorkspaceFile]` One record per rendered file ({ Target; Content }): the workspace root first, then the members
in ordinal folder order.

### example 1

```powershell
(New-PythonProject -Target 'python/pyproject.toml').Content
```

## The Python version

The one Python version is the python tool's `tools.yml` pin, read by address (reading config is global access,
[ADR-CONF-ADDRESSING](../../../drs/configuration/config-value-addressing.md)).

## The members

The members are the test holder's folders, each named by its folder, then the modules, each named by its name in kebab case. A member's name
is its full name, the folder under the python track's namespace
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)); the folder never spells it.
