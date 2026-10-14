# docs/references/automation/catzc-base-languages.md

`Catzc.Base.Languages`

Owns the test languages beside PowerShell: today Go, whose code in this repository is test artifacts only. It declares the Go test workspace
once (`go.yml`), renders the generated `go.work` and `go.mod` files from it, and runs a catzc module's Go tests, returning one result per Go
test. It does not install the `go` tool (that is [Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md)'s), write the rendered files (that is
[Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s, per [ADR-REPO-ROOTCFG](../../adr/repository/generated-root-configs.md)), or turn the
results into Pester tests (that is the test harness's, in [Catzc.Base.QualityGates](catzc-base-qualitygates.md)).

## Responsibilities

| Responsibility   | Area   | Name                                                     |
| ---------------- | ------ | -------------------------------------------------------- |
| responsibility:1 | run    | [Go test runs](#responsibility1--go-test-runs)           |
| responsibility:2 | render | [Go test workspace](#responsibility2--go-test-workspace) |

### responsibility:1 — Go test runs

Running one catzc module's Go tests and reporting each one. The tests live in `go/tests/<module-in-kebab>/` (`Catzc.Base.Repository` →
`catzc-base-repository`), one Go module per catzc module. A run fetches the declared dependencies (which records `go.sum`), vets the test
packages, and runs every test uncached as a `go test -json` event stream, each command inside its time safeguard. The tests are black-box:
they start the engine and assert on its output, and the engine entry reaches them through the environment — `CATZC_ENGINE_ENTRY` names the
repository's `importer.ps1` for the source run or the build's `Import-Catzc.ps1` for the build run, and `CATZC_REPOSITORY_ROOT` names the
repository root. Both are set for the run only and restored afterwards.

The event stream becomes one result per top-level Go test: its package, name, outcome (`pass`, `fail`, or `skip`), duration, everything it
printed, and its category. Subtests fold into their parent. The category comes from the name, in one place, the result type: a
`TestIntegrity*` test is `integrity`, every other test is `logic` ([ADR-AUTO-TEST#1](../../adr/automation/test-automation.md)). A failing Go
test is a result, not an error; a run throws, with the go output, only when `go vet` fails, when a test package does not build, or when a
package fails outside any test.

### responsibility:2 — Go test workspace

The one declared definition of the Go test workspace and its rendering. `go.yml` holds the go directive, the module-path prefix, and the
test dependencies; each key is optional, and its sensible default is declared once on the config type
([ADR-AUTO-DEFAULT](../../adr/automation/sensible-defaults.md)), which also validates the file at load and reports every violation at once.
The renderer discovers the Go test folders and composes the root `go.work` (the go directive and one sorted `use` entry per folder) and each
folder's `go.mod` (the module path `<module_root>/<folder>`, the go directive, and the sorted requires). Rendering is pure text — offline,
with no go call — and byte-stable, so the generated files are drift-checked like every other managed file. Nothing Go-specific is committed
but the `*_test.go` files: `go.work`, the `go.mod` files, and the `go.sum` files a run records are all generated and gitignored.

## What the module does

The workspace makes the Go test folders buildable and the run uses them: the renderer gives every folder its `go.mod` and joins them in one
`go.work`, and a run executes one folder's tests against the engine it is pointed at. The two meet in the folder convention — one kebab-case
folder per catzc module — which is also how the test harness maps the Go tests to their module for ordering, protection, and selection.

The module sits on [Catzc.Base.Config](catzc-base-config.md) for `go.yml`, [Catzc.Base.Objects](catzc-base-objects.md) for the config type's
record base, [Catzc.Base.Repository](catzc-base-repository.md) for the repository root, and [Catzc.Base.Execution](catzc-base-execution.md)
for the go commands, whose time limit is the `go` entry of [Catzc.Base.Timeouts](catzc-base-timeouts.md)' `timeouts.yml`. The root-config
registry names the renderer as the generator of the `go.work` and `go.mod` targets, and the harness's Go bridge calls the run once per
mapped module, tagging every result `L2` with its category.

## Division

The module's public functions and configuration file, sorted into the responsibilities above.

| Responsibility                       | Function          |
| ------------------------------------ | ----------------- |
| responsibility:1 — Go test runs      | `Invoke-GoTest`   |
| responsibility:2 — Go test workspace | `New-GoWorkspace` |
| config                               | `go.yml`          |
