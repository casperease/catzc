# ADR: Python modules and test artifacts — modules by layout, black-box tests of the engine, nothing shipped unpackaged

## Rules: ADR-AUTO-PY

### Rule ADR-AUTO-PY-PYTESTFOLDER

The Python root is `python` when the repository has a `python/` folder (the `python` track), else `.python`, declared by `python.yml`'s
`root` (ADR-AUTO-TESTLANG-ONEROOT). A **Python test folder** is the folder `<root>/tests/<module>/`, named for its catzc module in Python's
snake case (`Catzc.Base.Repository` → `base_repository`), holding that module's `test_*.py` files. A Python test is a top-level `test*`
function, its parametrised cases folded into one test; a `test_integrity*` test is `integrity`, every other test `logic`.

- [The layout](#the-layout)

### Rule ADR-AUTO-PY-PYWORKSPACE

The Python tests form one generated, gitignored uv workspace — uv's monorepo layout, and the Python form of `go.work` with a `go.mod` per
module: nothing Python-specific is committed but the `test_*.py` files. `New-PythonProject` renders the workspace root
`<root>/pyproject.toml`, a virtual root naming every member explicitly, and one member `<root>/tests/<module>/pyproject.toml` per Python
test folder, from `python.yml` — pure text, offline, and byte-stable — and `Build-RootConfig` writes them on import through wildcard
root-config entries, drift-checked by `Test-GeneratedFiles`. The workspace has one environment (`<root>/.venv`) and one lock
(`<root>/uv.lock`), both made by `Install-PythonWorkspace` (`uv sync --all-packages`, the one online step) and gitignored. A test run reads
the environment offline (`uv run --no-sync` with `UV_OFFLINE=1`) and never syncs; a missing `.venv` stops it naming
`Install-PythonWorkspace`. A test dependency is declared in `python.yml` with its exact version, never added by `uv add`.

- [A generated workspace](#a-generated-workspace)

### Rule ADR-AUTO-PY-ONEPYTHONVERSION

The repository has one Python version: the `python` tool's pin in `tools.yml`. The project's `requires-python` is that pin, read by address
(`global.tools.python.version`), and `python.yml` declares no Python version of its own.

- [One Python version](#one-python-version)

### Rule ADR-AUTO-PY-MANAGEDTOOLS

A Python test run uses the managed tools: uv, located through the existence check (`Resolve-ToolExecutable`,
ADR-AUTO-DEPS-ASSERTBEFOREINVOKE) and run by its path, and the uv-managed interpreter at the pin (ADR-AUTO-UVPY-UVHANDLESPYTHON). uv runs
with `UV_PYTHON_DOWNLOADS=never`, so it never fetches an interpreter itself, and `UV_OFFLINE=1`, so a run never syncs or resolves: the
environment is made by `Install-PythonWorkspace` (ADR-AUTO-PY-PYWORKSPACE), and the checks run pyright on its bundled copy at the
`python.yml` pin with node on `PATH`. A missing or off-pin uv stops `Invoke-PythonTest` with the remedy `Install-Uv`; a missing interpreter
stops `Install-PythonWorkspace` with the remedy `Install-Python`; a missing node stops the checks with the remedy `Install-NodeJs`.

- [The managed tools](#the-managed-tools)

### Rule ADR-AUTO-PY-EVERYFILELINTED

Every `.py` file the repository holds — the Python tests and the agent helpers under `.claude/` alike — takes the repository's checks where
a check reads Python, with the pinned ruff and the workspace's settings: `ruff format` through `Test-Formatting` (`Format-Code`, the `ruff`
engine), `ruff check` through the `Test-PythonLint` quality gate and before every Python test run, and the spelling check over `*.py`. The
glossary checks read PowerShell and markdown, so Python comments are outside their reach.

- [The checks](#the-checks)

### Rule ADR-AUTO-PY-EVERYFILETYPECHECKED

Every `.py` file the repository holds is type-checked by pyright, the engine of the Pylance editor extension, in one mode for the gate and
the editor alike: `python.yml`'s `type_checking`, `standard` by default, declared once on `PythonConfig`. The pinned pyright runs through
the `Test-PythonTypes` quality gate with the workspace's `[tool.pyright]` settings; the generated VS Code settings give Pylance the same
mode and the workspace interpreter, so a finding the editor shows is a finding the gate reports. A package a checked file imports is pinned
in `python.yml`, and a folder whose scripts import a sibling script is named in its `extra_paths`, so every import resolves in both.

- [The type check](#the-type-check)

## Context

Python is a test-artifact language: its modules exist by the layout, its tests prove the engine as a process from outside, and the test run
reaches them through the one bridge ([test-artifact-languages](../test-artifact-languages.md)). This record holds Python's spellings of that
shared decision and what is Python's own: the workspace, the version, the tools and the checks. Python is what most of the people who read
this repository write first, pytest needs no ceremony, and uv, the repository's one Python handler
([uv-python-handler](../uv-python-handler.md)), provisions both the interpreter and the test dependencies user-space on every platform.

Python projects tend to grow: a package, a virtual environment per folder, a lock file to keep in step, a test framework plugin per need.
The rules below keep one generated workspace with one environment for every member, so the language adds an entry, not a mechanism.

### Modules by layout

A Python module, such as the diagram renderer, is a folder under the Python root that the layout places
([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-modulesbylayout)), a tool the engine runs as a process. The
Python-based tools the devbox installs (the Azure CLI, Poetry) are a separate matter: they are tools, not code of the repository, each
installed in isolation through uv (ADR-AUTO-UVPY-TWOINSTALLSHAPES), and nothing here changes how.

### The layout

The Python root follows the one convention every test-artifact language's root follows
([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-oneroot)): `python/` when present, the `python` track, else
`.python/`, declared once on the `PythonConfig` type, whose `ResolveRoot` every caller asks. Under it, a Python test folder's name is the
module's repository normal form in Python's folder case, snake
([idiomatic-names](../idiomatic-names.md#rule-adr-auto-idiom-testfolderbyidiom)), so the folder is an importable Python name, as every
Python folder in the tree is.

### The engine start environment

A Python test is a black-box test ([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-blackbox)) that reads its
start contract from three variables: `CATZC_ENGINE_EXECUTABLE` and the `CATZC_ENGINE_START` arguments start the engine, and
`CATZC_REPOSITORY_ROOT` names the repository it works on. The test puts its command in place of `{command}` in the start arguments.
`Invoke-PythonTest` sets the variables for its uv commands only and restores the session's values afterwards. A source run's entry is the
repository's `importer.ps1`, a build run's the build's `Import-Catzc.ps1`, and every Python test runs once per execution engine.

### A generated workspace

The Python test workspace is configuration the repository states elsewhere: which folders are Python test folders (the folders on disk),
which Python version they use (the `tools.yml` pin), and which test dependencies they need (`python.yml`). `New-PythonProject` renders it,
and the root-config registry names it as the generator of the workspace files.

The layout is uv's own for a monorepo: a workspace. Its root, `<root>/pyproject.toml`, is virtual — it has no project of its own — and names
every member explicitly, as `go.work`'s `use` entries do; it also carries the ruff settings, which apply to every member (a 140-column line,
the pinned Python as target). Each Python test folder is a member with its own `pyproject.toml`, named for the folder, as each Go test
module has its `go.mod`. The members are virtual too — they build and install no package. A workspace gives each module's tests their own
identity while keeping one environment and one lock for all of them: separate environments per folder would be slow, use disk for nothing,
and could resolve different versions. The environment and lock are per-machine output of `uv sync --all-packages`, gitignored. The lock is
not committed, so `python.yml` pins exact versions: two machines resolve the same direct dependencies.

### One Python version

The Python version is a tool version, locked in `tools.yml` ([controlling-systemwide-deps](../controlling-systemwide-deps.md)), where the
uv-managed interpreter's pin already lives (ADR-AUTO-UVPY-AUTHORITATIVEPIN). The project's `requires-python` is that minor version, read by
address, so raising Python is one line in `tools.yml`.

### The managed tools

A test run runs uv by the path the existence check returns, never a bare `uv` off `PATH`, and uv runs the interpreter it manages at the pin.
uv would otherwise download a matching interpreter on demand; a test run sets `UV_PYTHON_DOWNLOADS=never`, so a missing interpreter is a
precondition failure with one remedy, `Install-Python`, rather than a silent network fetch. Python writes no bytecode into the tree during a
run.

### The bridge

The Python tests run through the one bridge ([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-bridge)), in a
`Test-Automation` test run ([test-automation](../test-automation.md)). The bridge runs `Invoke-PythonTest` once per mapped module —
`uv sync`, `ruff check`, then `pytest` with a JUnit report, the test folder as pytest's rootdir — and in pwsh each Python test is a Pester
`It`, tagged `L2`. Discovery reads the `test_*.py` files without running Python. The `PythonTestResult` type decides the category. uv is the
Python tests' tool: the run's source session locates it, with the interpreter at the pin, once (`Get-LanguageTestExecutable`); without
either, every Python test skips with `tool_uv_missing`.

### The checks

Every check that reads Python applies to every `.py` file the repository holds, wherever it lives: `ruff format` is the formatting standard
for `.py` files, applied by `Format-Code` and checked by `Test-Formatting`; `ruff check` lints them through the `Test-PythonLint` quality
gate, and lints a test folder again before every run of its tests; and the spelling check reads `*.py`. ruff is pinned in `python.yml` and
runs from the workspace environment with the workspace's settings passed explicitly, so every machine formats and lints every file — the
agent helpers outside the workspace too — with the same version and rules. The glossary checks read PowerShell, through its parser, and
markdown, so a Python comment is outside their reach.

### The type check

A lint finds a pattern; a type check finds a value that cannot be what the code assumes, such as an optional read as if it were always
there. pyright is the type checker the editor already runs, inside Pylance, so the gate runs pyright too: one engine, one mode and one
interpreter mean the editor and the gate never disagree, as the PSScriptAnalyzer settings tie the PowerShell editor to its gate. The mode is
configuration, not code ([configure-not-program](../../principles/configure-not-program.md)): `python.yml` names it, `PythonConfig` declares
the `standard` default once, `New-PythonProject` renders it into the workspace's `[tool.pyright]`, and the root-config generator renders it
into the VS Code settings with the workspace interpreter. The agent helpers import Pillow, so Pillow is pinned beside the test dependencies,
and they import each other by bare name from their own folder, which pyright does not search, so `python.yml`'s `extra_paths` names those
folders and both renderings carry them (`extraPaths`, `python.analysis.extraPaths`): an import the type check cannot resolve is a finding,
never a gap.

## Decision

Python is a language track whose modules exist by the layout and ship only what is packaged, and a black-box test language
(ADR-AUTO-TESTLANG-MODULESBYLAYOUT). Its tests of the engine live in one Python test folder per catzc module under the Python root
(ADR-AUTO-TESTLANG-ONEROOT, ADR-AUTO-PY-PYTESTFOLDER), start the engine from the entry the run names (ADR-AUTO-TESTLANG-BLACKBOX), run in
one generated, gitignored uv workspace (ADR-AUTO-PY-PYWORKSPACE) at the one pinned Python version (ADR-AUTO-PY-ONEPYTHONVERSION) with the
managed tools (ADR-AUTO-PY-MANAGEDTOOLS), and run through `Test-Automation` as `L2` tests through the one bridge (ADR-AUTO-TESTLANG-BRIDGE),
under the checks that read Python (ADR-AUTO-PY-EVERYFILELINTED) and one type check shared with the editor
(ADR-AUTO-PY-EVERYFILETYPECHECKED).

### How this is enforced

- **`PythonConfig`** (`Catzc.Base.Languages`) validates `python.yml` at load, requires the pyright, pytest and ruff pins, and declares the
  Python root's default once (`ResolveRoot`) and the type-checking mode's (`type_checking`).
- **`New-PythonProject`** renders the workspace root and one member per Python test folder and per module of the track, and throws when a
  test folder is not named in Python's folder case or the `tools.yml` pin is not a Python minor version. **`Build-RootConfig`** writes them,
  and **`Test-GeneratedFiles`** reports a stale one.
- **`Invoke-PythonTest`** runs the managed uv with `UV_PYTHON_DOWNLOADS=never`, sets the engine contract for its uv commands only, and
  returns one `PythonTestResult` per test function with its category.
- **The gitignore registry** (`gitignore.yml`) ignores the environment, the lock, and the caches.
- **The language bridge** in `Catzc.Base.QualityGates` (`Get-LanguageTestFolders`, `Get-PythonTestCases`, `Language.Bridge.ps1`) maps each
  Python test folder to its catzc module and tags each test.
- **The `ruff` formatter engine** in `Test-Formatting` (languages.yml gives Python `formatter: ruff`), the **`Test-PythonLint`** quality
  gate, and the spelling check's `*.py` scope apply the checks to every `.py` file the repository holds.
- **The `Test-PythonTypes`** quality gate runs the pinned pyright over the same files, and the root-config generator gives Pylance the same
  mode and interpreter in the generated VS Code settings.

## Consequences

- The engine is verified as a process in a second black-box language, in both run modes, through the harness every other test runs through.
- A new Python test folder is one folder with one `test_*.py` file: the next run discovers it, and nothing else changes.
- Python tests never reach a user, and an installed catzc needs no Python for them.
- The cost is uv and the pinned interpreter on every devbox and CI agent that runs the `L2` tests — both already part of the standard
  toolchain; without them, the Python tests skip and the run says so.
