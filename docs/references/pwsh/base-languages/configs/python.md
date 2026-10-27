# pwsh/Base.Languages/configs/python.yml

The Python test workspace: the one declaration that `New-PythonProject` renders the uv workspace from, the root `<root>/pyproject.toml` and
one member `<root>/tests/<folder>/pyproject.toml` per Python test folder. Python code in this repository is test artifacts only: black-box
tests under `<root>/tests/<module-in-kebab>/`, and nothing Python-specific is committed but the `test_*.py` files. The workspace is
generated and virtual (it builds no package); its one environment (`<root>/.venv`) and one lock (`<root>/uv.lock`) are made by uv in the
test bridge and gitignored.

Every key but `dependencies` is optional: an omitted key takes the sensible default declared once on `Catzc.Base.Languages.PythonConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Keys

- **`root`** — the Python root folder, repository-relative: the test folders live in `<root>/tests/<module>/`, and the workspace root, its
  environment and its lock live in `<root>/`. Not declared here, so it takes the default every test language's root takes: `python` when the
  repository has a `python/` folder (a Python root track), else `.python`, the dot-prefixed tooling folder. Declare it (for example
  `root: test/python`) only to place the Python root elsewhere.
- **`dependencies`** — the test dependencies every member requires, distribution name to exact version. pytest runs the tests and ruff
  formats and lints them; both are required. The lock is not committed, so exact pins keep every machine on the same versions.

## The Python version

The Python version is not declared here. It is the python tool's pin in `tools.yml` (`global.tools.python.version`), the one Python version,
rendered as every member's `requires-python`.

## How it is read

`Get-Config -Config python` loads the file into the typed `PythonConfig` record, which validates the shape (`PythonConfig.cs`).
