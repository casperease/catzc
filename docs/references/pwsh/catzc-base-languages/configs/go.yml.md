# pwsh/Base.Languages/configs/go.yml

The Go workspace: the one declaration that `New-GoWorkspace` renders the repository-root `go.work` and every `go.mod` from, one per test
module under `<root>/tests/<module-in-kebab>/` and one per module folder of the go track. Nothing Go-specific is committed but the Go files
themselves.

Every key is optional: an omitted key takes the sensible default declared once on `Catzc.Base.Languages.GoConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Keys

- **`root`** — the Go root folder, repository-relative: the test modules live in `<root>/tests/<module>/`, and `go.work` stays at the
  repository root with one `use ./<root>/tests/<module>` entry per module. Not declared here, so it takes the default: `go` when the
  repository has a `go/` folder (a Go root track), else `.go`, the dot-prefixed tooling folder. Declare it (for example `root: test/go`)
  only to place the Go root elsewhere.
- **`module_root`** — the module-path prefix. A test folder `<root>/tests/<folder>/` is the Go module `<module_root>/tests/<folder>`, and a
  module folder `<root>/<Module>/` of the track is `<module_root>/<Module>`. Default: `catzc/go`.
- **`dependencies`** — the test dependencies every `go.mod` requires, module path to version (`vX.Y.Z`). The `go.mod` files are rendered and
  never tidied, so a dependency's own requirements are declared here too. Default: none; the standard library's `testing` package is enough
  for black-box tests that start the engine and assert on its output.

## The go directive

The `go` directive of `go.work` and every `go.mod` is not declared here. It is the go tool's pin in `tools.yml` (`global.tools.go.version`),
the one Go version, so the workspace never asks for a newer toolchain than the one installed.

## How it is read

`Get-Config -Config go` loads the file into the typed `GoConfig` record, which validates the shape (`GoConfig.cs`).
