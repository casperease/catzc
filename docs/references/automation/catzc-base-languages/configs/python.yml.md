# docs/references/automation/catzc-base-languages/configs/python.yml.md

`automation/Catzc.Base.Languages/configs/python.yml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `dependencies:`.

```text
The Python test workspace — the one declared source that New-PythonProject renders the uv workspace from: the root
<root>/pyproject.toml and one member <root>/tests/<folder>/pyproject.toml per Python test folder. Python code in this
repository is test artifacts only: black-box tests under <root>/tests/<module-in-kebab>/, and nothing Python-specific is
committed but the test_*.py files. The workspace is generated and virtual (it builds no package); its one environment
(<root>/.venv) and one lock (<root>/uv.lock) are made by uv in the test bridge and gitignored.

Every key but the dependencies is optional: an omitted key takes the sensible default declared once on
Catzc.Base.Languages.PythonConfig ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
Loaded via Get-Config -Config python; the shape is validated by the PythonConfig type.

The Python version is not declared here: it is the python tool's pin in tools.yml (global.tools.python.version), the
one Python version, rendered as every member's requires-python.
```

## comment:2

Above `dependencies:`.

```text
root — the Python root folder, repository-relative: the test folders live in <root>/tests/<module>/, and the workspace
root, its environment and its lock live in <root>/. Not declared here, so it takes the default every test language's
root takes: 'python' when the repository has a python/ folder (a Python root track), else '.python', the dot-prefixed
tooling folder. Declare it (e.g. `root: test/python`) only to place the Python root elsewhere.
```

## comment:3

Above `dependencies:`.

```text
The test dependencies every member requires: distribution name -> exact version. pytest runs the tests and ruff formats
and lints them; both are required. The lock is not committed, so exact pins keep every machine on the same versions.
```
