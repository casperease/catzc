# docs/adr/automation/python/python-test-artifacts.md

`ADR: Python test artifacts — black-box tests of the engine, never shipped`

## Rules: ADR-AUTO-PY

### Rule ADR-AUTO-PY:1

Python code in the repository is test artifacts and nothing else: `test_*.py` files that verify the engine from outside. No module,
function, or tool of the engine is written in Python, and no Python test file ships — the Python root lies outside `automation/`, so
`Build-Modules` never sees it and no bundle holds a Python test, by construction. Python-based tools the repository uses (the Azure CLI,
Poetry) are tools, installed through uv (ADR-AUTO-UVPY#2); they are not code of the repository. The agent helpers under `.claude/` (the
draw.io scripts) are configuration of the agent tool, outside every track, and outside this rule; they still take the spelling check.

- [Test artifacts only](#test-artifacts-only)

### Rule ADR-AUTO-PY:2

The Python tests live under the Python root, `python/`, a conventional root folder hardcoded once (`PythonConfig.Root`, ADR-REPO-FOLDERS#7).
A **Python test folder** is the folder `python/tests/<module>/`, one per catzc module and named for it in kebab case
(`Catzc.Base.Repository` → `catzc-base-repository`), holding that module's `test_*.py` files. A Python test is a top-level `test*` function;
a parametrised test is one test.

- [The layout](#the-layout)

### Rule ADR-AUTO-PY:3

A Python test is a black-box test under the contract the Go tests follow (ADR-AUTO-GO#3): it starts the engine (`pwsh -NoProfile`) with the
script named by `CATZC_ENGINE_ENTRY` and asserts on output and exit codes, never on the engine's internals; `CATZC_REPOSITORY_ROOT` names
the repository root. `Invoke-PythonTest` sets both for its uv commands only and restores them afterwards.

- [The black-box contract](#the-black-box-contract)

### Rule ADR-AUTO-PY:4

The Python test project is generated and gitignored: nothing Python-specific is committed but the `test_*.py` files. `New-PythonProject`
renders the one virtual uv project, `python/pyproject.toml`, from `python.yml` — pure text, offline, and byte-stable — and
`Build-RootConfig` writes it on import, drift-checked by `Test-GeneratedFiles`. Every test folder shares that one project, so there is one
environment (`python/.venv`) and one lock (`python/uv.lock`), both made by `uv sync` in a test run and gitignored. A test dependency is
declared in `python.yml` with its exact version, never added by `uv add`.

- [A generated project](#a-generated-project)

### Rule ADR-AUTO-PY:5

The repository has one Python version: the `python` tool's pin in `tools.yml`. The project's `requires-python` is that pin, read by address
(`global.tools.python.version`), and `python.yml` declares no Python version of its own.

- [One Python version](#one-python-version)

### Rule ADR-AUTO-PY:6

A Python test run uses the managed tools: uv, located through the existence check (`Resolve-ToolExecutable`, ADR-AUTO-DEPS#3) and run by its
path, and the uv-managed interpreter at the pin (ADR-AUTO-UVPY#1). uv runs with `UV_PYTHON_DOWNLOADS=never`, so it never fetches an
interpreter itself. A missing or off-pin uv stops `Invoke-PythonTest` with the remedy `Install-Uv`; a missing interpreter stops `uv sync`
with the remedy `Install-Python`.

- [The managed tools](#the-managed-tools)

### Rule ADR-AUTO-PY:7

`Test-Automation` runs the Python tests through the language bridge the Go tests run through (ADR-AUTO-GO#7): discovery maps each Python
test folder to its catzc module, and the bridge turns every top-level Python test into one Pester test, tagged `L2` (ADR-AUTO-TEST#9) plus a
category from its name — `test_integrity*` is `integrity`, every other test is `logic`. The run's source session locates uv once and hands
its path to the bridge; without uv or the interpreter at the pin, the bridge skips with `tool_uv_missing` (ADR-AUTO-TEST#8).

- [The bridge](#the-bridge)

### Rule ADR-AUTO-PY:8

Python code takes the repository's checks where a check reads Python: `ruff format` through `Test-Formatting` (`Format-Python`),
`ruff check` before every Python test run, and the spelling check over `*.py`. The glossary checks read PowerShell and markdown, so Python
comments are outside their reach.

- [The checks](#the-checks)

## Context

The engine is verified as a process, from outside, by tests in a second language ([go test artifacts](../go/test-artifacts.md)). Python is
the second such language: it is what most of the people who read this repository write first, pytest needs no ceremony, and uv — already the
repository's one Python handler ([uv-python-handler](../uv-python-handler.md)) — provisions both the interpreter and the test dependencies
user-space on every platform.

The risks are the ones Go carried, and one more. Python projects tend to grow: a package, a virtual environment per folder, a lock file to
keep in step, a test framework plugin per need. The rules below hold Python to test artifacts, keep one generated project for every test
folder, and run the tests through the same bridge as Go, so a third language adds an entry, not a mechanism.

### Test artifacts only

Python code exists only as tests. The engine is PowerShell and C# ([tracks](../../design/tracks.md#rule-adr-dsgn-track3)); a Python test
verifies it from outside, as a black box. Because the Python root lies outside `automation/`, the builder's input holds no Python test, so
no check is needed to keep one out of a bundle ([platform-bundle](../platform-bundle.md)). The Python-based tools the devbox installs are a
separate matter: they are tools, each installed in isolation through uv, and nothing here changes how.

### The layout

`python/` is the Python root and the `python` track, of the verification class ([tracks](../../design/tracks.md#rule-adr-dsgn-track2)).
Unlike Go's, it is not a setting: Python has no competing idiom for where test code lives, so the conventional name is hardcoded once, on
`PythonConfig` ([conventional-folders](../../repository/conventional-folders.md#rule-adr-repo-folders7)). Under it, `tests/<module>/` holds
one Python test folder per catzc module, named for that module in kebab case — the convention that maps a folder to its module with no
mapping file, shared with the Go test modules. A hyphen is no problem for Python here: the tests are collected by path, never imported as a
package.

### The black-box contract

A Python test knows what a Go test knows, from the same two environment variables, and does what a Go test does: it starts
`pwsh -NoProfile`, dot-sources the entry, runs a command, and asserts on the output and exit code. The same test therefore proves both run
modes ([run-modes](../../design/run-modes.md)): the entry names the repository's `importer.ps1` in a source run and the build's
`Import-Catzc.ps1` in a build run.

### A generated project

The Python test project is configuration the repository states elsewhere: the Python version (the `tools.yml` pin) and the test dependencies
(`python.yml`). `New-PythonProject` renders it, with the ruff settings that match the repository's own (a 140-column line, the pinned Python
as target), and the root-config registry names it as the generator of `python/pyproject.toml`
([generated-root-configs](../../repository/generated-root-configs.md)).

One project serves every test folder. A project per folder, as Go has a module per folder, would give each folder its own environment and
lock with nothing different in them, since every folder runs the same pytest against the same engine. The project is virtual — it builds and
installs no package — and its environment and lock are per-machine output of `uv sync`, gitignored. The lock is not committed, so
`python.yml` pins exact versions: two machines resolve the same direct dependencies.

### One Python version

The Python version is a tool version, locked in `tools.yml` ([controlling-systemwide-deps](../controlling-systemwide-deps.md)), where the
uv-managed interpreter's pin already lives (ADR-AUTO-UVPY#4). The project's `requires-python` is that minor version, read by address
([config-value-addressing](../../configuration/config-value-addressing.md)), so raising Python is one line in `tools.yml`.

### The managed tools

A test run runs uv by the path the existence check returns, never a bare `uv` off `PATH`, and uv runs the interpreter it manages at the pin.
uv would otherwise download a matching interpreter on demand; a test run sets `UV_PYTHON_DOWNLOADS=never`, so a missing interpreter is a
precondition failure with one remedy, `Install-Python`, rather than a silent network fetch — the Python form of `GOTOOLCHAIN=local`
(ADR-AUTO-GO#6). Python writes no bytecode into the tree during a run.

### The bridge

A Python test runs where every other test runs: in a `Test-Automation` test run, in both run modes, under the same selection, ordering,
protection, tiers, categories, and report ([test-automation](../test-automation.md)). The one language bridge runs `Invoke-PythonTest` once
per mapped module — `uv sync`, `ruff check`, then `pytest` with a JUnit report, the test folder as pytest's rootdir — and turns each
top-level test function into a Pester test, its parametrised cases folded into it, as Go folds subtests. Discovery reads the `test_*.py`
files without running Python, so it is fast, offline, and works where uv is missing.

A Python test starts a real engine through a real toolchain, so every one is `L2`. Its category comes from its name, decided in one place
(the `PythonTestResult` type). uv is a tool of the harness, not part of what ships: the run's source session locates it, with the
interpreter, once (`Get-LanguageTestExecutable`), and hands the path to the bridge, so a build run tests the build without carrying the
tools config.

### The checks

Every check that reads Python applies to Python: `ruff format` is the formatting standard for `.py` files
([uniform-formatting](../../repository/uniform-formatting.md)), applied by `Format-Python` and checked by `Test-Formatting`; `ruff check`
lints the test folder before every run; and the spelling check reads `*.py`. ruff is pinned in `python.yml` and runs from the project
environment, so every machine formats and lints with the same version. The glossary checks read PowerShell, through its parser, and markdown
([controlled-vocabulary](../../repository/controlled-vocabulary.md)), so a Python comment is outside their reach.

## Decision

Python is a black-box test language and nothing else (ADR-AUTO-PY#1). Its tests live in one Python test folder per catzc module under
`python/` (ADR-AUTO-PY#2), start the engine from the entry the run names (ADR-AUTO-PY#3), run in one generated, gitignored project
(ADR-AUTO-PY#4) at the one pinned Python version (ADR-AUTO-PY#5) with the managed tools (ADR-AUTO-PY#6), and run through `Test-Automation`
as `L2` tests through the language bridge (ADR-AUTO-PY#7), under the checks that read Python (ADR-AUTO-PY#8).

### How this is enforced

- **`PythonConfig`** (`Catzc.Base.Languages`) validates `python.yml` at load, requires the pytest and ruff pins, and names the Python root.
- **`New-PythonProject`** renders `python/pyproject.toml`, and throws when the `tools.yml` pin is not a Python minor version.
  **`Build-RootConfig`** writes it, and **`Test-GeneratedFiles`** reports a stale one.
- **`Invoke-PythonTest`** runs the managed uv with `UV_PYTHON_DOWNLOADS=never`, sets the engine contract for its uv commands only, and
  returns one `PythonTestResult` per test function with its category.
- **The gitignore registry** (`gitignore.yml`) ignores the environment, the lock, and the caches.
- **The language bridge** in `Catzc.Base.QualityGates` (`Get-LanguageTestFolders`, `Get-PythonTestCases`, `Language.Bridge.ps1`) maps each
  Python test folder to its catzc module and tags each test.
- **`Format-Python`** in `Test-Formatting` and the spelling check's `*.py` scope apply the checks.

## Consequences

- The engine is verified as a process in a second black-box language, in both run modes, through the harness every other test runs through.
- A new Python test folder is one folder with one `test_*.py` file: the next run discovers it, and nothing else changes.
- Python tests never reach a user, and an installed catzc needs no Python for them.
- The cost is uv and the pinned interpreter on every devbox and CI agent that runs the `L2` tests — both already part of the standard
  toolchain; without them, the Python tests skip and the run says so.
