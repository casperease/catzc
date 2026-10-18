# Catzc.Base.Languages

Owns the test languages beside PowerShell: Go, Python and Bash, whose code in this repository is test artifacts only. For Go and Python it
declares the generated workspace once (`go.yml`, `python.yml`) and renders the generated files from it (`go.work` and a `go.mod` per module;
a uv workspace root and a member `pyproject.toml` per module); for Bash it declares the vendored test runner's pin (`bash.yml`); and for
each it runs a catzc module's tests, returning one result per test. It does not install the tools (that is
[Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md)'s and the uv tooling's), write the rendered files (that is
[Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s, per [ADR-REPO-ROOTCFG](../../adr/repository/generated-root-configs.md)), or turn the
results into Pester tests (that is the test harness's language bridge, in [Catzc.Base.QualityGates](catzc-base-qualitygates.md)).

## Responsibilities

| Responsibility   | Area   | Name                                                             |
| ---------------- | ------ | ---------------------------------------------------------------- |
| responsibility:1 | run    | [Go test runs](#responsibility1--go-test-runs)                   |
| responsibility:2 | render | [Go test workspace](#responsibility2--go-test-workspace)         |
| responsibility:3 | run    | [Python test runs](#responsibility3--python-test-runs)           |
| responsibility:4 | render | [Python test workspace](#responsibility4--python-test-workspace) |
| responsibility:5 | run    | [Bash test runs](#responsibility5--bash-test-runs)               |

### responsibility:1 — Go test runs

Running one catzc module's Go tests and reporting each one. The tests live in `<root>/tests/<module-in-kebab>/` under the Go root
(`Catzc.Base.Repository` → `catzc-base-repository`), one Go module per catzc module. Every go command runs inside that module folder, so a
`./...` pattern expands below the module root and a dot-prefixed Go root works like any other. A run uses the managed `go`, located by its
path from the tool's `tools.yml` entry, never a bare `go` off `PATH`; when none is found, or the one found does not match the pin, the run
stops and names `Install-Go`. A run fetches the declared dependencies (which records `go.sum`), vets the test packages, and runs every test
uncached as a `go test -json` event stream, each command inside its time safeguard. The tests are black-box: they start the engine and
assert on its output, and how to start it reaches them through the environment, from the execution engine model
([ADR-AUTO-ENGINE](../../adr/automation/execution-engines.md)) — `CATZC_ENGINE_EXECUTABLE` names the engine's executable and
`CATZC_ENGINE_START` its start arguments, which load the repository's `importer.ps1` for the source run or the build's `Import-Catzc.ps1`
for the build run and end in the test's command; `CATZC_REPOSITORY_ROOT` names the repository root. They are set for the run only and
restored afterwards.

The event stream becomes one result per top-level Go test: its package, name, outcome (`pass`, `fail`, or `skip`), duration, everything it
printed, and its category. Subtests fold into their parent. The category comes from the name, in one place, the result type: a
`TestIntegrity*` test is `integrity`, every other test is `logic` ([ADR-AUTO-TEST#1](../../adr/automation/test-automation.md)). A failing Go
test is a result, not an error; a run throws, with the go output, only when `go vet` fails, when a test package does not build, or when a
package fails outside any test.

### responsibility:2 — Go test workspace

The one declared definition of the Go test workspace and its rendering. `go.yml` holds the Go root, the module-path prefix, and the test
dependencies. The Go root defaults to `go` when the repository has a `go/` folder (a Go root track), else to `.go`, the dot-prefixed tooling
folder ([ADR-REPO-FOLDERS](../../adr/repository/conventional-folders.md)); a declared `root` places it anywhere else. `go.work` always stays
at the repository root, the idiomatic workspace place that an editor's Go language server finds with no setting, and its `use` entries name
every test module explicitly, so both layouts load the same in every editor. The go directive is the `go` tool's pin in `tools.yml`, the one
Go version, so the workspace never asks for a newer toolchain than the managed one. Each `go.yml` key is optional, and its sensible default
is declared once on the config type ([ADR-AUTO-DEFAULT](../../adr/automation/sensible-defaults.md)), which also validates the file at load
and reports every violation at once. The renderer discovers the Go test folders and composes `go.work` (the go directive and one sorted
`use` entry per folder) and each folder's `go.mod` (the module path `<module_root>/<folder>`, the go directive, and the sorted requires).
Rendering is pure text — offline, with no go call — and byte-stable, so the generated files are drift-checked like every other managed file.
Nothing Go-specific is committed but the `*_test.go` files: `go.work`, the `go.mod` files, and the `go.sum` files a run records are all
generated and gitignored.

### responsibility:3 — Python test runs

Running one catzc module's Python tests and reporting each one ([ADR-AUTO-PY](../../adr/automation/python/python-test-artifacts.md)). The
tests live in `<root>/tests/<module-in-kebab>/` under the Python root, and every test folder is a member of the one generated uv workspace
there, with one environment for all of them. A run uses the managed `uv`, located by its path from the tool's `tools.yml` entry, and the
uv-managed interpreter at the `python` pin; uv never downloads an interpreter during a run, so a missing one stops the run with the remedy
`Install-Python`, and a missing `uv` names `Install-Uv`. A run syncs the workspace's environment, lints the test folder with `ruff check`,
and runs `pytest` with the folder as its rootdir and a JUnit report, each command inside its time safeguard and under the same engine
contract as the Go tests (`CATZC_ENGINE_EXECUTABLE`, `CATZC_ENGINE_START`, `CATZC_REPOSITORY_ROOT`).

The report becomes one result per top-level test function, with the same shape as a Go result — package, name, outcome, duration, output,
and category — so the harness treats both alike. Parametrised cases fold into their function. A `test_integrity*` test is `integrity`, every
other test is `logic`. A failing test is a result; a run throws, with the tool output, when the sync or the lint fails, or when pytest fails
without a failing test (a collection error, or no tests).

### responsibility:4 — Python test workspace

The one declared definition of the Python test workspace and its rendering. `python.yml` holds the Python root and the test dependencies,
pinned exactly — `pytest` and `ruff` are required. The Python root defaults, by the convention every test language's root follows, to
`python` when the repository has a `python/` folder, else to `.python` ([ADR-REPO-FOLDERS](../../adr/repository/conventional-folders.md)); a
declared `root` places it anywhere else. The renderer composes uv's monorepo layout: the workspace root `<root>/pyproject.toml`, virtual (no
project of its own), naming every member explicitly and carrying the ruff settings that match the repository (a 140-column line, the pinned
Python as target); and one member `<root>/tests/<folder>/pyproject.toml` per Python test folder, a virtual project named for the folder
whose `requires-python` is the `python` pin in `tools.yml`, the one Python version, with the dependencies in name order. A repository
without Python test folders gets no workspace. Rendering is pure text, offline and byte-stable. The workspace has one environment and one
lock; both, and the workspace files, are generated and gitignored.

### responsibility:5 — Bash test runs

Running one catzc module's Bash tests and reporting each one ([ADR-AUTO-BASH](../../adr/automation/bash/bash-test-artifacts.md)). The tests
are `.bats` files in `<root>/tests/<module-in-kebab>/` under the Bash root, which defaults, by the convention every test language's root
follows, to `bash` when the repository has a `bash/` folder, else to `.bash`. They run on the bats-core runner vendored under the Bash root
at `.vendor/bats-core/`, whose release and archive digest `bash.yml` pins, under the bash engine only, from the Bash root, with a JUnit
report and inside the time safeguard. A Bash test calls catzc the way a Bash user does: it loads `importer.sh` (`CATZC_ENGINE_ENTRY`) and
runs commands through `cats`, which loads the entry `CATZC_IMPORTER` names — the repository's `importer.ps1` for the source run, the build's
`Import-Catzc.ps1` for the build run.

The report becomes one result per `@test`, with the shape of a Go result — package (the `.bats` file's path in the folder), name, outcome,
duration, output, and category. A name starting with `integrity:` is `integrity`, every other test is `logic`. A failing test is a result; a
run throws, with the bats output, when the vendored runner is missing (naming `Update-BatsVendor`), or when bats fails without a failing
test.

## What the module does

The workspace makes the Go test folders buildable and the run uses them: the renderer gives every folder its `go.mod` and joins them in one
`go.work`, and a run executes one folder's tests against the engine it is pointed at. The two meet in the folder convention — one kebab-case
folder per catzc module — which is also how the test harness maps the Go tests to their module for ordering, protection, and selection.

The module sits on [Catzc.Base.Config](catzc-base-config.md) for `go.yml` and the `tools.yml` pin (read by address, as global config
access), [Catzc.Base.Objects](catzc-base-objects.md) for the config type's record base, [Catzc.Base.Repository](catzc-base-repository.md)
for the repository root, and [Catzc.Base.Execution](catzc-base-execution.md) for locating the managed `go` and running the go commands,
whose time limit is the `go` entry of [Catzc.Base.Timeouts](catzc-base-timeouts.md)' `timeouts.yml`. The root-config registry names the
renderer as the generator of the `go.work` and `go.mod` targets — one record per file, written by
[Catzc.Base.RootConfig](catzc-base-rootconfig.md) — and the harness's language bridge calls the run once per mapped module, tagging every
result `L2` with its category. Python follows the same shape — a uv workspace root in place of `go.work`, a member `pyproject.toml` in place
of each `go.mod` — with one environment and one lock for the whole workspace; the renderer is the generator of the workspace targets, and
the same bridge calls the Python run. Bash needs no workspace: its runner is vendored, and the same bridge calls the Bash run under the bash
engine. The engine start environment every run sets comes from one helper over the execution engine model, so the Go and Python tests run
under either engine unchanged.

## Division

The module's public functions and configuration file, sorted into the responsibilities above.

| Responsibility                           | Function            |
| ---------------------------------------- | ------------------- |
| responsibility:1 — Go test runs          | `Invoke-GoTest`     |
| responsibility:2 — Go test workspace     | `New-GoWorkspace`   |
| config                                   | `go.yml`            |
| responsibility:3 — Python test runs      | `Invoke-PythonTest` |
| responsibility:4 — Python test workspace | `New-PythonProject` |
| config                                   | `python.yml`        |
| responsibility:5 — Bash test runs        | `Invoke-BashTest`   |
| config                                   | `bash.yml`          |
