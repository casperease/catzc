# ADR: Go modules and test artifacts — modules by layout, black-box tests of the engine, nothing shipped unpackaged

## Rules: ADR-AUTO-GO

### Rule ADR-AUTO-GO-GOMODULESBYLAYOUT

Go code in the repository is either a module of the `go` track, a folder under the Go root that exists by the layout
(ADR-AUTO-MODULE-EXISTSBYLAYOUT, ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE), or a black-box test under the track's test holder,
`<root>/tests/<module>/`. A Go module ships only what `files.yml` packages, and a test file never ships: the builder's input is the engine's
track, so no bundle holds a Go file by construction. No function of the engine is written in Go; a Go module is a tool of the repository
that the engine runs as a process.

- [Modules by layout](#modules-by-layout)

### Rule ADR-AUTO-GO-ONEGOROOT

The Go tests live under one Go root, a repository-relative folder declared by `go.yml`'s `root` with a sensible default: `go` when the
repository has a `go/` folder (the `go` track), else the dot-prefixed `.go`. A **Go test module** is the folder `<root>/tests/<module>/`,
one per catzc module and named for it as one lowercase word, Go's flat case (`Catzc.Base.Repository` → `baserepository`,
ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM), holding that module's Go tests as one Go module. `go.work` sits at the repository root and lists every Go
test module explicitly, and every go command runs inside its module folder, so every editor loads either layout with no setting.

- [The layout](#the-layout)

### Rule ADR-AUTO-GO-GOBLACKBOX

A Go test is a black-box test: it starts the engine from the contract its runner sets (ADR-AUTO-ENGINE-STARTENVIRONMENT) —
`CATZC_ENGINE_EXECUTABLE`, with the `CATZC_ENGINE_START` arguments, which load the run's entry and end in the test's command — runs
commands, and asserts on their output and exit codes, never on the engine's internals. The entry is the repository's importer entry in a
source run and the build's entry script in a build run (ADR-AUTO-TEST-SAMETESTSBOTHRUNS); `CATZC_REPOSITORY_ROOT` names the repository root.
`Invoke-GoTest` sets them for its go commands only and restores them afterwards, so the same Go test proves both run modes unchanged.

- [The engine start environment](#the-engine-start-environment)

### Rule ADR-AUTO-GO-GOWORKSPACE

The Go workspace is generated and gitignored: nothing Go-specific is committed but the `*_test.go` files. `New-GoWorkspace` renders
`go.work` and every `go.mod` from `go.yml` — pure text, offline, and byte-stable — and `Build-RootConfig` writes them on import through a
wildcard root-config entry, drift-checked by `Test-GeneratedFiles`. The `go.sum` files come from `go mod download`, which a Go test run
makes first. A test dependency is declared in `go.yml` with its version, never added by `go get` or `go mod tidy`.

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

### Rule ADR-AUTO-GO-GOBRIDGE

`Test-Automation` runs the Go tests through a bridge: discovery maps each Go test module to its catzc module, so ordering, protection,
`-Modules`, `-Suite`, the tiers, and both runs apply as to the module's own tests, and the bridge turns every top-level Go test into one
test of the run (ADR-AUTO-TEST-TEST). Every Go test is tagged `L2` — a real tool and a real engine (ADR-AUTO-TEST-NOCLOUDBELOWLTHREE) — plus
a category from its name: `TestIntegrity*` is `integrity`, every other test is `logic`. The run's source session locates the managed `go`
once and hands its path to the bridge beside the engine entry; a worker never locates `go` itself, so a build run tests the build without
carrying the tools config. Without the managed `go`, the bridge skips with `tool_go_missing` (ADR-AUTO-TEST-TAGBYOUTERMOSTRING).

- [The bridge](#the-bridge)

### Rule ADR-AUTO-GO-GOCHECKS

Go code takes the repository's checks where a check reads Go: `gofmt` through `Test-Formatting`, `go vet` before every Go test run, and the
spelling check over `*.go`. The glossary checks read PowerShell and markdown, so Go comments are outside their reach.

- [The checks](#the-checks)

## Context

The engine's own tests are Pester tests that load the modules in-process and call functions directly. That is the right tool for the
engine's logic, and the wrong one for the question a user asks: does the engine, started as a process the way a user or a pipeline starts
it, do what it says? A test written in a second language cannot reach into the engine's session at all, so it can only ask that question —
it starts the engine, sends it commands, and reads what comes back. Go suits the role: one static toolchain, a standard `testing` package
with no framework to install, a machine-readable event stream (`go test -json`), and fast parallel test runs.

The risk of a second language is a second tech-stack spreading through the repository: Go helpers beside the PowerShell functions, a Go
build in the bundle, a second set of committed module files to keep in step. The rules below hold Go to modules by layout and test
artifacts, keep everything Go-specific but the code generated, and run the tests through the harness every other test runs through.

### Modules by layout

The `go` track is a language track like `pwsh` ([module-model](../module-model.md#rule-adr-auto-module-everylanguagetrackalike)): a module
is a folder under the Go root that the layout places, and the tests of the engine sit in the track's own holder. The engine stays PowerShell
and C# ([tracks](../../design/tracks.md#rule-ddr-track-onetechstack)); a Go test verifies it from outside, as a black box, and nothing in
the engine calls Go. The builder reads the engine's track, so no bundle holds a Go file unless `files.yml` packages it — the layout is the
guarantee ([platform-bundle](../platform-bundle.md)).

### The layout

The Go root is the one folder every Go file lives under. When the repository has a `go/` folder, that folder is the root, and it is the `go`
track ([tracks](../../design/tracks.md#rule-ddr-track-onetracktype)). Otherwise the root is `.go/`, dot-prefixed as the tooling folders are.
The default is declared once, on the `GoConfig` type ([sensible-defaults](../sensible-defaults.md)), and `go.yml` declares a `root` only to
place the Go root elsewhere.

Under the root, `tests/<module>/` holds one Go test module per catzc module, named for that module by rendering the module's repository
normal form in Go's folder case, flat ([idiomatic-names](../idiomatic-names.md#rule-adr-auto-idiom-testfolderbyidiom)); the same rendering
lets the harness map a Go test module to its catzc module with no mapping file. Each folder is its own Go module, with the module path
`<module_root>/tests/<folder>` (`catzc/go/tests/<folder>` by default); a module folder of the track is `<module_root>/<Module>`.

`go.work` stays at the repository root, the place an editor's Go language server (gopls in VS Code, GoLand, vim) looks for a workspace with
no setting. Its `use` entries name every Go test module explicitly rather than by a pattern, nothing hides the Go root from the editor, and
every go command runs inside the module folder, so a `./...` pattern expands below the module root and a dot in an ancestor folder changes
nothing. Both layouts — `go/` and `.go/` — therefore load the same in every editor.

### The engine start environment

A Go test knows two things about the engine, both from the environment: how to start it (`CATZC_ENGINE_EXECUTABLE` and the
`CATZC_ENGINE_START` arguments) and the repository it works on (`CATZC_REPOSITORY_ROOT`). The start comes from the execution engine model
([execution-engines](../execution-engines.md)): it starts the engine non-interactively, loads the entry with its output discarded, and ends
in the command text, where the test puts its command in place of `{command}`. The test never builds a command line of its own, so it holds
no engine's quoting rule and runs unchanged under either engine. The variables are an external contract between the run and the go processes
it starts ([environment-variables](../environment-variables.md#rule-adr-auto-envvar-setonlyfortools)), so `Invoke-GoTest` sets them for its
go commands only and restores the session's values afterwards.

The entry is the only difference between the two runs ([run-modes](../../design/run-modes.md)). A source run names the repository's
`importer.ps1`; a build run names the build's `Import-Catzc.ps1`. The Go tests are the same files in both, exactly as the Pester tests are
(ADR-AUTO-TEST-SAMETESTSBOTHRUNS), so "works in both modes" holds for the engine as a process too.

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

A Go test is a test of the repository like any other, so it runs where every other test runs: in a `Test-Automation` test run, in both run
modes, under the same selection, ordering, protection, tiers, categories, and report
([test-automation](../test-automation.md#rule-adr-auto-test-languagetestmodules)). The one language bridge every test language shares (Go
and Python, [python-test-artifacts](../python/python-test-artifacts.md)) runs `Invoke-GoTest` once per mapped module — `go mod download`,
`go vet`, then `go test -json` — and turns each top-level Go test into one test of the run, with its subtests folded into it. In pwsh that
test is a Pester `It`.

A Go test starts a real engine through a real toolchain, so the bridge tags every one `L2`, with no per-test choice to make. Its category
comes from its name, decided in one place (the `GoTestResult` type): a `TestIntegrity*` test reads the shipped artifacts and is `integrity`;
every other test is `logic`. Both axes stay mandatory and checked, exactly as for a Pester test (ADR-AUTO-TEST-TWOMANDATORYTAGS).

`go` is a tool of the harness, not part of the engine under test. A build run's workers load the build, which holds only the selected
modules and so not the `tools` config that `Resolve-ToolExecutable` reads. The run's source session therefore locates `go` once
(`Get-LanguageTestExecutable`) and hands the path down beside the engine entry: through the shard script, the Pester configuration, and the
bridge container's data. An empty path means no managed `go` at the pin, and every Go test skips with `tool_go_missing`. The bundle under
test stays exactly what ships.

### The checks

Every check that reads Go applies to Go: `gofmt` is the formatting standard for `.go` files, applied by `Format-Code` (the `gofmt` engine
languages.yml names for Go) and checked by `Test-Formatting` with the managed toolchain's own `gofmt`, `go vet` type-checks and vets the
test packages before every run, and the spelling check reads `*.go`. The glossary checks read PowerShell, through its parser, and markdown,
so a Go comment is outside their reach.

## Decision

Go is a language track whose modules exist by the layout and ship only what is packaged, and the repository's first black-box test language
(ADR-AUTO-GO-GOMODULESBYLAYOUT). Its tests of the engine live in one Go test module per catzc module under the Go root
(ADR-AUTO-GO-ONEGOROOT), start the engine from the entry the run names (ADR-AUTO-GO-GOBLACKBOX), build against a generated, gitignored
workspace (ADR-AUTO-GO-GOWORKSPACE) at the one pinned Go version (ADR-AUTO-GO-ONEGOVERSION) with the managed toolchain
(ADR-AUTO-GO-MANAGEDTOOLCHAIN), and run through `Test-Automation` as `L2` tests (ADR-AUTO-GO-GOBRIDGE), under the checks that read Go
(ADR-AUTO-GO-GOCHECKS).

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
