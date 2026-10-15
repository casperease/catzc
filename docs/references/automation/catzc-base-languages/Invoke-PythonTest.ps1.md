# docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md

`automation/Catzc.Base.Languages/Invoke-PythonTest.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
In the module's Python test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;
the Python root is python.yml's `root`, by default python/ when the repository has one, else .python/), runs three uv
commands from the Python root, the uv workspace root, through Invoke-Executable, each inside its time safeguard (the
`uv` entry of timeouts.yml). It runs the managed uv by its path: the caller's -UvExecutable, or the one located from
its tools.yml entry by Resolve-ToolExecutable, never a bare uv off PATH; it throws with "Run Install-Uv" when no uv
at the pin is found.

  uv sync --all-packages                            makes the workspace's one environment (<root>/.venv) and lock
                                                    from the generated workspace (New-PythonProject);
  uv run --no-sync ruff check tests/<folder>        lints the test files (the go vet of Python);
  uv run --no-sync pytest tests/<folder> ...        runs every test, uncached, with the folder as pytest's rootdir
                                                    and a JUnit XML report.

uv runs with UV_PYTHON_DOWNLOADS=never, so it uses the uv-managed interpreter at the tools.yml python pin and
never fetches one silently (the Python form of GOTOOLCHAIN=local; a missing interpreter fails uv sync with the
remedy Install-Python). Python writes no bytecode into the tree (PYTHONDONTWRITEBYTECODE=1).

The Python tests are black-box tests: they start the engine and assert on its output. How to start it reaches
them through the environment (Get-EngineContract), set for these commands only and restored afterwards:

  CATZC_ENGINE_EXECUTABLE  the engine's executable;
  CATZC_ENGINE_START       the arguments after it, as a JSON array that loads the entry — the repository's
                           importer.ps1 for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a
                           build run — and ends in the command text, with {command} where the test's command goes;
  CATZC_REPOSITORY_ROOT    the repository root.

Returns one PythonTestResult per top-level test function (parametrised cases fold into it), with its category
from its name: test_integrity* is integrity, everything else is logic. A failing test is a result, not an
error. The call throws, with the uv output, when uv sync or ruff check fails, and when pytest fails without a
failing test (a collection error, or no tests).
```

## comment:2

Section `.PARAMETER EntryScript` of the comment-based help.

```text
The engine entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
source run).
```

## comment:3

Section `.PARAMETER UvExecutable` of the comment-based help.

```text
The uv to run, already located and checked against the pin by the caller: a test run passes the uv its source
session resolved, because a build run's engine does not carry the tools.yml entry. Default: located here by
Resolve-ToolExecutable.
```

## comment:4

Section `.PARAMETER Engine` of the comment-based help.

```text
The execution engine the tests start: pwsh (default) or bash, which reaches catzc through importer.sh's cats
dispatcher ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). The tests are the same; only the contract
they read changes.
```

## comment:5

Above `$pythonRelative = (Get-Config -Config python).ResolveRoot($root)`.

```text
The Python root from python.yml (PythonConfig.ResolveRoot: the declared root, else python/ when present, else
.python/): the uv workspace root.
```

## comment:6

Above `$uvPath = if ($UvExecutable) {`.

```text
The managed uv, by its path: the caller's, already located and checked, or located here from its tools.yml entry
(Resolve-ToolExecutable); never a bare uv off PATH.
```

## comment:7

Above `$environment = Get-EngineContract -Engine $Engine -EngineExecutable...`.

```text
How the tests start the engine (Get-EngineContract) is an external contract with the test processes
([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
commands only, then restored. UV_PYTHON_DOWNLOADS=never keeps uv on the managed interpreter at the pin
([ADR-AUTO-PY#6](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py6)).
```

## comment:8

Above `if ($run.ExitCode -ne 0 -and -not ($run.ExitCode -eq 1 -and @($results |...`.

```text
pytest exits 1 when a test failed; any other non-zero exit, or 1 with no failing test, means it failed around
the tests (a usage or collection error, or no tests collected: exit 5).
```
