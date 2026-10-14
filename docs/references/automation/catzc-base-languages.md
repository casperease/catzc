# docs/references/automation/catzc-base-languages.md

`Catzc.Base.Languages`

Owns the test languages beside PowerShell: Go and Python, whose code in this repository is test artifacts only. For each it declares the
generated project once (`go.yml`, `python.yml`), renders the generated files from it (`go.work` and `go.mod`; `python/pyproject.toml`), and
runs a catzc module's tests, returning one result per test. It does not install the tools (that is
[Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md)'s and the uv tooling's), write the rendered files (that is
[Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s, per [ADR-REPO-ROOTCFG](../../adr/repository/generated-root-configs.md)), or turn the
results into Pester tests (that is the test harness's language bridge, in [Catzc.Base.QualityGates](catzc-base-qualitygates.md)).

## Responsibilities

| Responsibility   | Area   | Name                                                         |
| ---------------- | ------ | ------------------------------------------------------------ |
| responsibility:1 | run    | [Go test runs](#responsibility1--go-test-runs)               |
| responsibility:2 | render | [Go test workspace](#responsibility2--go-test-workspace)     |
| responsibility:3 | run    | [Python test runs](#responsibility3--python-test-runs)       |
| responsibility:4 | render | [Python test project](#responsibility4--python-test-project) |

### responsibility:1 — Go test runs

Running one catzc module's Go tests and reporting each one. The tests live in `<root>/tests/<module-in-kebab>/` under the Go root
(`Catzc.Base.Repository` → `catzc-base-repository`), one Go module per catzc module. Every go command runs inside that module folder, so a
`./...` pattern expands below the module root and a dot-prefixed Go root works like any other. A run uses the managed `go`, located by its
path from the tool's `tools.yml` entry, never a bare `go` off `PATH`; when none is found, or the one found does not match the pin, the run
stops and names `Install-Go`. A run fetches the declared dependencies (which records `go.sum`), vets the test packages, and runs every test
uncached as a `go test -json` event stream, each command inside its time safeguard. The tests are black-box: they start the engine and
assert on its output, and the engine entry reaches them through the environment — `CATZC_ENGINE_ENTRY` names the repository's `importer.ps1`
for the source run or the build's `Import-Catzc.ps1` for the build run, and `CATZC_REPOSITORY_ROOT` names the repository root. Both are set
for the run only and restored afterwards.

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
tests live in `python/tests/<module-in-kebab>/`, and every test folder runs in the one generated test project under `python/`. A run uses
the managed `uv`, located by its path from the tool's `tools.yml` entry, and the uv-managed interpreter at the `python` pin; uv never
downloads an interpreter during a run, so a missing one stops the run with the remedy `Install-Python`, and a missing `uv` names
`Install-Uv`. A run syncs the project's environment, lints the test folder with `ruff check`, and runs `pytest` with the folder as its
rootdir and a JUnit report, each command inside its time safeguard and under the same engine contract as the Go tests (`CATZC_ENGINE_ENTRY`,
`CATZC_REPOSITORY_ROOT`).

The report becomes one result per top-level test function, with the same shape as a Go result — package, name, outcome, duration, output,
and category — so the harness treats both alike. Parametrised cases fold into their function. A `test_integrity*` test is `integrity`, every
other test is `logic`. A failing test is a result; a run throws, with the tool output, when the sync or the lint fails, or when pytest fails
without a failing test (a collection error, or no tests).

### responsibility:4 — Python test project

The one declared definition of the Python test project and its rendering. `python.yml` pins the test dependencies exactly — `pytest` and
`ruff` are required — and the type that validates it also names the Python root, `python`, hardcoded once because Python has no competing
layout idiom ([ADR-REPO-FOLDERS](../../adr/repository/conventional-folders.md)). The renderer composes `python/pyproject.toml`: a virtual
project (it builds no package) whose `requires-python` is the `python` pin in `tools.yml`, the one Python version, with the dependencies in
name order and the ruff settings that match the repository (a 140-column line, the pinned Python as target). Rendering is pure text, offline
and byte-stable. Every test folder shares the project, so there is one environment and one lock; both, and the project file, are generated
and gitignored.

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
result `L2` with its category. Python follows the same shape with one difference: one project for every test folder rather than one per
folder, because every Python test folder shares the same dependencies; the renderer is the generator of `python/pyproject.toml`, and the
same bridge calls the Python run.

## Division

The module's public functions and configuration file, sorted into the responsibilities above.

| Responsibility                         | Function            |
| -------------------------------------- | ------------------- |
| responsibility:1 — Go test runs        | `Invoke-GoTest`     |
| responsibility:2 — Go test workspace   | `New-GoWorkspace`   |
| config                                 | `go.yml`            |
| responsibility:3 — Python test runs    | `Invoke-PythonTest` |
| responsibility:4 — Python test project | `New-PythonProject` |
| config                                 | `python.yml`        |
