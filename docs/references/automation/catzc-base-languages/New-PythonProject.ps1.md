# automation/Catzc.Base.Languages/New-PythonProject.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders the Python test workspace: the uv workspace root `<root>/pyproject.toml` and one member pyproject.toml per Python test folder.

### description

Python code in this repository is test artifacts only: black-box tests in `<root>/tests/<module-in-kebab>/`, under the Python root
(python.yml `root`: python/ when the repository has one, else .python/;
[ADR-AUTO-PY](../../../adr/automation/python/python-test-artifacts.md)). The tests form one uv workspace — uv's own monorepo layout, and the
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

uv makes one environment (`<root>/.venv`) and one lock (`<root>/uv.lock`) for the whole workspace when the test bridge syncs it; both are
gitignored, as these files are. A repository without Python test folders renders nothing.

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

## comment:1

Above `$pythonVersion = "$(Get-ConfigValue -Address 'global.tools.python.version')"`, written with `#`.

```text
The one Python version: the python tool's tools.yml pin, read by address (reading config is global access,
[ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)).
```
