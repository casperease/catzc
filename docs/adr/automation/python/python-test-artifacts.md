# ADR: Python modules and test artifacts — modules by layout, black-box tests of the engine, nothing shipped unpackaged

## Rules: ADR-AUTO-PY

### Rule ADR-AUTO-PY-MODULESBYLAYOUT

Python code in the repository is either a module of the `python` track, a folder under the Python root that exists by the layout
(ADR-AUTO-MODULE-EXISTSBYLAYOUT, ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE), or a black-box test under the track's test holder,
`<root>/tests/<module>/`. A Python module ships only what `files.yml` packages, and a test file never ships: the builder's input is the
engine's track, so no bundle holds a Python file by construction. No function of the engine is written in Python; the engine is PowerShell
and C#, and a Python module is a tool of the repository, such as the diagram renderer, that the engine runs as a process. Python-based tools
the repository uses (the Azure CLI, Poetry) are tools, installed through uv (ADR-AUTO-UVPY-TWOINSTALLSHAPES); they are not code of the
repository. Every `.py` file takes every Python check (ADR-AUTO-PY-EVERYFILELINTED).

- [Modules by layout](#modules-by-layout)

### Rule ADR-AUTO-PY-ONEPYTHONROOT

The Python tests live under one Python root, a repository-relative folder declared by `python.yml`'s `root` with the sensible default every
test language's root takes: `python` when the repository has a `python/` folder (the `python` track), else the dot-prefixed `.python`. A
**Python test folder** is the folder `<root>/tests/<module>/`, one per catzc module and named for it in kebab case (`Catzc.Base.Repository`
→ `catzc-base-repository`), holding that module's `test_*.py` files. A Python test is a top-level `test*` function; a parametrised test is
one test.

- [The layout](#the-layout)

### Rule ADR-AUTO-PY-BLACKBOXTESTS

A Python test is a black-box test under the contract the Go tests follow (ADR-AUTO-GO-BLACKBOXTESTS, ADR-AUTO-ENGINE-STARTENVIRONMENT): it
starts the engine from `CATZC_ENGINE_EXECUTABLE` with the `CATZC_ENGINE_START` arguments, which load the run's entry and end in the test's
command, and asserts on output and exit codes, never on the engine's internals; `CATZC_REPOSITORY_ROOT` names the repository root.
`Invoke-PythonTest` sets them for its uv commands only and restores them afterwards.

- [The engine start environment](#the-engine-start-environment)

### Rule ADR-AUTO-PY-GENERATEDWORKSPACE

The Python tests form one generated, gitignored uv workspace — uv's monorepo layout, and the Python form of `go.work` with a `go.mod` per
module: nothing Python-specific is committed but the `test_*.py` files. `New-PythonProject` renders the workspace root
`<root>/pyproject.toml`, a virtual root naming every member explicitly, and one member `<root>/tests/<module>/pyproject.toml` per Python
test folder, from `python.yml` — pure text, offline, and byte-stable — and `Build-RootConfig` writes them on import through wildcard
root-config entries, drift-checked by `Test-GeneratedFiles`. The workspace has one environment (`<root>/.venv`) and one lock
(`<root>/uv.lock`), both made by `uv sync --all-packages` and gitignored. A test dependency is declared in `python.yml` with its exact
version, never added by `uv add`.

- [A generated workspace](#a-generated-workspace)

### Rule ADR-AUTO-PY-ONEPYTHONVERSION

The repository has one Python version: the `python` tool's pin in `tools.yml`. The project's `requires-python` is that pin, read by address
(`global.tools.python.version`), and `python.yml` declares no Python version of its own.

- [One Python version](#one-python-version)

### Rule ADR-AUTO-PY-MANAGEDTOOLS

A Python test run uses the managed tools: uv, located through the existence check (`Resolve-ToolExecutable`,
ADR-AUTO-DEPS-ASSERTBEFOREINVOKE) and run by its path, and the uv-managed interpreter at the pin (ADR-AUTO-UVPY-UVHANDLESPYTHON). uv runs
with `UV_PYTHON_DOWNLOADS=never`, so it never fetches an interpreter itself. A missing or off-pin uv stops `Invoke-PythonTest` with the
remedy `Install-Uv`; a missing interpreter stops `uv sync` with the remedy `Install-Python`.

- [The managed tools](#the-managed-tools)

### Rule ADR-AUTO-PY-LANGUAGEBRIDGE

`Test-Automation` runs the Python tests through the language bridge the Go tests run through (ADR-AUTO-GO-LANGUAGEBRIDGE): discovery maps
each Python test folder to its catzc module, and the bridge turns every top-level Python test into one test of the run (ADR-AUTO-TEST-TEST),
tagged `L2` (ADR-AUTO-TEST-NOCLOUDBELOWLTHREE) plus a category from its name — `test_integrity*` is `integrity`, every other test is
`logic`. The run's source session locates uv once and hands its path to the bridge; without uv or the interpreter at the pin, the bridge
skips with `tool_uv_missing` (ADR-AUTO-TEST-TAGBYOUTERMOSTRING).

- [The bridge](#the-bridge)

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

The engine is verified as a process, from outside, by tests in a second language ([go test artifacts](../go/go-test-artifacts.md)). Python
is the second such language: it is what most of the people who read this repository write first, pytest needs no ceremony, and uv — already
the repository's one Python handler ([uv-python-handler](../uv-python-handler.md)) — provisions both the interpreter and the test
dependencies user-space on every platform.

The risks are the ones Go carried, and one more. Python projects tend to grow: a package, a virtual environment per folder, a lock file to
keep in step, a test framework plugin per need. The rules below hold Python to modules by layout and test artifacts, keep one generated
workspace with one environment for every member, and run the tests through the same bridge as Go, so a third language adds an entry, not a
mechanism.

### Modules by layout

The `python` track is a language track like `pwsh` ([module-model](../module-model.md#rule-adr-auto-module-everylanguagetrackalike)): a
module is a folder under the Python root that the layout places, and the tests of the engine sit in the track's own holder. The engine stays
PowerShell and C# ([tracks](../../design/tracks.md#rule-adr-dsgn-track-onetechstack)); a Python module is a tool the engine runs as a
process, and a Python test verifies the engine from outside, as a black box. The builder reads the engine's track, so no bundle holds a
Python file unless `files.yml` packages it ([platform-bundle](../platform-bundle.md)). The Python-based tools the devbox installs are a
separate matter: they are tools, each installed in isolation through uv, and nothing here changes how.

### The layout

The Python root is the one folder every Python file lives under. When the repository has a `python/` folder, that folder is the root, and it
is the `python` track ([tracks](../../design/tracks.md#rule-adr-dsgn-track-onetracktype)). Otherwise the root is `.python/`, dot-prefixed as
the tooling folders are. This is the one convention every test language's root follows, Go's included
([conventional-folders](../../repository/conventional-folders.md#rule-adr-repo-folders-literalnames)): the default is declared once, on the
`PythonConfig` type ([sensible-defaults](../sensible-defaults.md)), `PythonConfig.ResolveRoot` is the one resolver every caller asks, and
`python.yml` declares a `root` only to place the Python root elsewhere.

Under the root, `tests/<module>/` holds one Python test folder per catzc module, named for that module in kebab case — the convention that
maps a folder to its module with no mapping file, shared with the Go test modules. A hyphen is no problem for Python here: the tests are
collected by path, never imported as a package.

### The engine start environment

A Python test knows what a Go test knows, from the same environment variables, and does what a Go test does: it starts the engine from the
executable and start arguments the contract names ([execution-engines](../execution-engines.md)), puts its command in place of `{command}`,
and asserts on the output and exit code. It never builds a command line itself, so it holds no engine's quoting rule. The same test
therefore proves both run modes ([run-modes](../../design/run-modes.md)): the entry the start loads is the repository's `importer.ps1` in a
source run and the build's `Import-Catzc.ps1` in a build run.

### A generated workspace

The Python test workspace is configuration the repository states elsewhere: which folders are Python test folders (the folders on disk),
which Python version they use (the `tools.yml` pin), and which test dependencies they need (`python.yml`). `New-PythonProject` renders it,
and the root-config registry names it as the generator of the workspace files
([generated-root-configs](../../repository/generated-root-configs.md#rule-adr-repo-rootcfg-wildcardgenerator)).

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
address ([config-value-addressing](../../configuration/config-value-addressing.md)), so raising Python is one line in `tools.yml`.

### The managed tools

A test run runs uv by the path the existence check returns, never a bare `uv` off `PATH`, and uv runs the interpreter it manages at the pin.
uv would otherwise download a matching interpreter on demand; a test run sets `UV_PYTHON_DOWNLOADS=never`, so a missing interpreter is a
precondition failure with one remedy, `Install-Python`, rather than a silent network fetch — the Python form of `GOTOOLCHAIN=local`
(ADR-AUTO-GO-MANAGEDTOOLCHAIN). Python writes no bytecode into the tree during a run.

### The bridge

A Python test runs where every other test runs: in a `Test-Automation` test run, in both run modes, under the same selection, ordering,
protection, tiers, categories, and report ([test-automation](../test-automation.md)). The one language bridge runs `Invoke-PythonTest` once
per mapped module — `uv sync`, `ruff check`, then `pytest` with a JUnit report, the test folder as pytest's rootdir — and turns each
top-level test function into one test of the run, its parametrised cases folded into it, as Go folds subtests; in pwsh that test is a Pester
`It` ([pester-testing](../pwsh/pester-testing.md#rule-adr-pwsh-pester-languagebridge)). Discovery reads the `test_*.py` files without
running Python, so it is fast, offline, and works where uv is missing.

A Python test starts a real engine through a real toolchain, so every one is `L2`. Its category comes from its name, decided in one place
(the `PythonTestResult` type). uv is a tool of the harness, not part of what ships: the run's source session locates it, with the
interpreter, once (`Get-LanguageTestExecutable`), and hands the path to the bridge, so a build run tests the build without carrying the
tools config.

### The checks

Every check that reads Python applies to every `.py` file the repository holds, wherever it lives: `ruff format` is the formatting standard
for `.py` files ([uniform-formatting](../../repository/uniform-formatting.md)), applied by `Format-Code` and checked by `Test-Formatting`;
`ruff check` lints them through the `Test-PythonLint` quality gate, and lints a test folder again before every run of its tests; and the
spelling check reads `*.py`. ruff is pinned in `python.yml` and runs from the workspace environment with the workspace's settings passed
explicitly, so every machine formats and lints every file — the agent helpers outside the workspace too — with the same version and rules.
The glossary checks read PowerShell, through its parser, and markdown ([controlled-vocabulary](../../repository/controlled-vocabulary.md)),
so a Python comment is outside their reach.

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
(ADR-AUTO-PY-MODULESBYLAYOUT). Its tests of the engine live in one Python test folder per catzc module under the Python root
(ADR-AUTO-PY-ONEPYTHONROOT), start the engine from the entry the run names (ADR-AUTO-PY-BLACKBOXTESTS), run in one generated, gitignored uv
workspace (ADR-AUTO-PY-GENERATEDWORKSPACE) at the one pinned Python version (ADR-AUTO-PY-ONEPYTHONVERSION) with the managed tools
(ADR-AUTO-PY-MANAGEDTOOLS), and run through `Test-Automation` as `L2` tests through the language bridge (ADR-AUTO-PY-LANGUAGEBRIDGE), under
the checks that read Python (ADR-AUTO-PY-EVERYFILELINTED) and one type check shared with the editor (ADR-AUTO-PY-EVERYFILETYPECHECKED).

### How this is enforced

- **`PythonConfig`** (`Catzc.Base.Languages`) validates `python.yml` at load, requires the pyright, pytest and ruff pins, and declares the
  Python root's default once (`ResolveRoot`) and the type-checking mode's (`type_checking`).
- **`New-PythonProject`** renders the workspace root and one member per Python test folder and per module of the track, and throws when a
  test folder is not named in kebab case or the `tools.yml` pin is not a Python minor version. **`Build-RootConfig`** writes them, and
  **`Test-GeneratedFiles`** reports a stale one.
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
