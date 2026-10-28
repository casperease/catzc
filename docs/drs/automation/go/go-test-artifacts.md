# Automation: Go modules and test artifacts — modules by layout, black-box tests of the engine, nothing shipped unpackaged

## Rules: ADR-AUTO-GO

### Rule ADR-AUTO-GO-GOTESTMODULE

The Go root is `go` when the repository has a `go/` folder (the `go` track), else `.go`, declared by `go.yml`'s `root`
(ADR-AUTO-TESTLANG-ONEROOT). A **Go test module** is the folder `<root>/tests/<module>/`, named for its catzc module as one lowercase word,
Go's flat case (`Catzc.Base.Repository` → `baserepository`), holding that module's Go tests as one Go module. A Go test is a top-level
`Test*` function, its subtests folded into it; a `TestIntegrity*` test is `integrity`, every other test `logic`.

- [The layout](#the-layout)

### Rule ADR-AUTO-GO-GOWORKSPACE

The Go workspace is generated and gitignored: nothing Go-specific is committed but the `*_test.go` files. `New-GoWorkspace` renders
`go.work` and every `go.mod` from `go.yml` — pure text, offline, and byte-stable — and `Build-RootConfig` writes them on import through a
wildcard root-config entry, drift-checked by `Test-GeneratedFiles`. `go.work` sits at the repository root and lists every Go test module
explicitly, and every go command runs inside its module folder, so every editor loads either layout with no setting. The `go.sum` files come
from `go mod download`, which a Go test run makes first, offline (the module proxy off, `-mod=mod`, `GOTOOLCHAIN=local`) from the module
cache; `Invoke-Go '-C <folder> mod download'` is the command that fills that cache. A test dependency is declared in `go.yml` with its
version, never added by `go get` or `go mod tidy`.

- [A generated workspace](#a-generated-workspace)

### Rule ADR-AUTO-GO-ONEGOVERSION

The repository has one Go version: the `go` tool's pin in `tools.yml`. The go directive of `go.work` and every `go.mod` is that pin, read by
address (`global.tools.go.version`), and `go.yml` declares no Go version of its own, so the workspace never asks for a toolchain newer than
the managed one.

- [One Go version](#one-go-version)

### Rule ADR-AUTO-GO-MANAGEDTOOLCHAIN

A Go test run uses the managed toolchain, located through the existence check (`Resolve-ToolExecutable`, ADR-AUTO-DEPS-ASSERTBEFOREINVOKE)
and run by its path, never a bare `go` off `PATH`, with `GOTOOLCHAIN=local` so it never switches to a toolchain it downloads itself. A
missing `go`, or one whose version misses the pin, stops `Invoke-GoTest` with the remedy `Install-Go`, which installs the pinned release
user-space from the go.dev archive; a machine-wide Go is left in place, and the managed copy is found first.

- [The managed toolchain](#the-managed-toolchain)

### Rule ADR-AUTO-GO-GOCHECKS

Go code takes the repository's checks where a check reads Go: `gofmt` through `Test-Formatting`, `go vet` before every Go test run, and the
spelling check over `*.go`. The glossary checks read PowerShell and markdown, so Go comments are outside their reach.

- [The checks](#the-checks)

## Context

Go is a test-artifact language: its modules exist by the layout, its tests prove the engine as a process from outside, and the test run
reaches them through the one bridge ([test-artifact-languages](../test-artifact-languages.md)). This record holds Go's spellings of that
shared decision and what is Go's own: the workspace, the version and the toolchain. Go suits the role: one static toolchain, a standard
`testing` package with no framework to install, a machine-readable event stream (`go test -json`), and fast parallel test runs. Everything
Go-specific but the code is generated, so a second language adds no committed module files to keep in step.

### The layout

The Go root follows the one convention every test-artifact language's root follows
([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-oneroot)): `go/` when present, the `go` track, else `.go/`,
declared once on the `GoConfig` type. Under it, a Go test module's name is the module's repository normal form in Go's folder case, flat
([idiomatic-names](../idiomatic-names.md#rule-adr-auto-idiom-testfolderbyidiom)). Each folder is its own Go module, with the module path
`<module_root>/tests/<folder>` (`catzc/go/tests/<folder>` by default); a module folder of the track is `<module_root>/<Module>`.

`go.work` stays at the repository root, the place an editor's Go language server (gopls in VS Code, GoLand, vim) looks for a workspace with
no setting. Its `use` entries name every Go test module explicitly rather than by a pattern, nothing hides the Go root from the editor, and
every go command runs inside the module folder, so a `./...` pattern expands below the module root and a dot in an ancestor folder changes
nothing. Both layouts — `go/` and `.go/` — therefore load the same in every editor.

### The engine start environment

A Go test is a black-box test ([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-blackbox)) that reads its
start contract from three variables: `CATZC_ENGINE_EXECUTABLE` and the `CATZC_ENGINE_START` arguments start the engine, and
`CATZC_REPOSITORY_ROOT` names the repository it works on. The test puts its command in place of `{command}` in the start arguments.
`Invoke-GoTest` sets the variables for its go commands only and restores the session's values afterwards. A source run's entry is the
repository's `importer.ps1`, a build run's the build's `Import-Catzc.ps1`, and every Go test runs once per execution engine.

### A generated workspace

Go's workspace files are configuration that the repository states elsewhere: which folders are Go test modules (the folders on disk), what
their module paths are, which Go version they use (the `tools.yml` pin), and which test dependencies they require (`go.yml`). Committing
`go.work` and the `go.mod` files would state those facts a second time, where they drift. So `New-GoWorkspace` renders them — the go
directive, one sorted `use` entry per Go test module, and each module's path and sorted requires — as pure text with no go call, offline and
byte-stable, and the root-config registry names it as their generator. They are gitignored copies, written on every import and drift-checked
like every other generated file.

The `go.mod` files are rendered and never tidied, so a dependency's own requirements are declared in `go.yml` too, and `go get` or
`go mod tidy` has nothing to write that the next import does not overwrite. The checksums are the one part the renderer cannot produce
offline: `go mod download`, the first step of every Go test run, records `go.sum`, which is gitignored per-machine output.

### One Go version

The Go version is a tool version, and tool versions are locked in `tools.yml`
([controlling-systemwide-deps](../controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions)). The go directive in the workspace
is that pin, read by its address, so raising Go is one line in `tools.yml`: the next import renders the new directive, and `Install-Go`
installs the new release. A second version in `go.yml` would be a second source of truth, and one that could ask for a toolchain the managed
install does not have.

### The managed toolchain

`go` on `PATH` can be any Go — a machine-wide install, an older release, a different home. A Go test run therefore asks the existence check
([controlling-systemwide-deps](../controlling-systemwide-deps.md#3-assert-at-runtime)) for the managed `go` (`Resolve-ToolExecutable`): the
managed home's binary first, then `PATH`, with no process start, then one version check per session. The run uses the path the check
returns. Left alone, `go` reads the workspace's `go` directive and, when its own release is older, silently downloads that toolchain and
runs it, so an off-pin `go` would pass the version check and the run would fetch from the network unannounced. The version check therefore
runs each executable in its own folder, outside any workspace, and `Invoke-GoTest` sets `GOTOOLCHAIN=local` for its `go` commands. A missing
or mismatched `go` is a precondition failure, reported with the one remedy, `Install-Go`. `Install-Go` installs the pinned release from the
official go.dev archive, verified against the SHA-256 the release feed publishes, into a user-space home on every platform; a machine-wide
Go stays where it is, and the managed copy, found first, is the one the run uses.

### The bridge

The Go tests run through the one bridge ([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-bridge)), in a
`Test-Automation` test run ([test-automation](../test-automation.md#rule-adr-auto-test-languagetestmodules)). The bridge runs
`Invoke-GoTest` once per mapped module — `go mod download`, `go vet`, then `go test -json` — and in pwsh each Go test is a Pester `It`,
tagged `L2`. The `GoTestResult` type decides the category: a `TestIntegrity*` test reads the shipped artifacts and is `integrity`. `go` is
the Go tests' tool: the run's source session locates the managed `go` once (`Get-LanguageTestExecutable`) and hands its path down through
the shard script, the Pester configuration, and the bridge container's data. An empty path means no managed `go` at the pin, and every Go
test skips with `tool_go_missing`.

### The checks

Every check that reads Go applies to Go: `gofmt` is the formatting standard for `.go` files, applied by `Format-Code` (the `gofmt` engine
languages.yml names for Go) and checked by `Test-Formatting` with the managed toolchain's own `gofmt`, `go vet` type-checks and vets the
test packages before every run, and the spelling check reads `*.go`. The glossary checks read PowerShell, through its parser, and markdown,
so a Go comment is outside their reach.

## Decision

Go is a language track whose modules exist by the layout and ship only what is packaged, and the repository's first black-box test language
(ADR-AUTO-TESTLANG-MODULESBYLAYOUT). Its tests of the engine live in one Go test module per catzc module under the Go root
(ADR-AUTO-TESTLANG-ONEROOT, ADR-AUTO-GO-GOTESTMODULE), start the engine from the entry the run names (ADR-AUTO-TESTLANG-BLACKBOX), build
against a generated, gitignored workspace (ADR-AUTO-GO-GOWORKSPACE) at the one pinned Go version (ADR-AUTO-GO-ONEGOVERSION) with the managed
toolchain (ADR-AUTO-GO-MANAGEDTOOLCHAIN), and run through `Test-Automation` as `L2` tests through the one bridge (ADR-AUTO-TESTLANG-BRIDGE),
under the checks that read Go (ADR-AUTO-GO-GOCHECKS).

### How this is enforced

- **`GoConfig`** (`Catzc.Base.Languages`) validates `go.yml` at load and declares the defaults once: the Go root (`ResolveRoot`), the
  module-path prefix, and the test dependencies.
- **`New-GoWorkspace`** renders `go.work` and every `go.mod`, one per Go test module and one per module of the track, and throws when a Go
  test module is not named in Go's folder case or the `tools.yml` pin is not a Go language version. **`Build-RootConfig`** writes them, and
  **`Test-GeneratedFiles`** reports a stale one.
- **`Invoke-GoTest`** locates the managed `go` through **`Resolve-ToolExecutable`** and **`Find-Executable`** (`Catzc.Base.Execution`), sets
  the engine contract for its go commands only, and returns one `GoTestResult` per Go test with its category.
- **The gitignore registry** (`gitignore.yml`) ignores the generated workspace and its checksum files.
- **The language bridge** in `Catzc.Base.QualityGates` (`Get-LanguageTestFolders`, `Language.Bridge.ps1`) maps each Go test module to its
  catzc module and tags each Go test.

## Consequences

- The engine is verified as a process, the way it is used, in both run modes, by tests that cannot depend on its internals.
- Nothing Go-specific is committed but the tests, so a new Go test module is one folder with one `*_test.go` file: the next import renders
  its `go.mod` and adds it to `go.work`.
- Go never reaches a user: no bundle holds a Go file, and no installed catzc needs a Go toolchain.
- The cost is a second toolchain on every devbox and CI agent that runs the `L2` tests, installed by `Install-Go`; without it, the Go tests
  skip and the run says so.
